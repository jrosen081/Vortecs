//
//  InputControllerTableViewController.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/5/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import UIKit

class InputController: UITableViewController {
	var source: VectorInteractor?
	var controller: UpdateController?
	weak var displayer: UIViewController?
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: self.tableView.rowHeight / 10, right: 0)
		self.tableView.separatorStyle = .singleLine
	}
	
	/// Update the specific cell
	/// - Parameter idx: The index of the cell to update
	func updateCell(at idx: Int) {
		if let cell = self.tableView.cellForRow(at: IndexPath(item: idx, section: 0)) as? VectorCell {
			self.controller?.updateCell(at: idx, cell: cell)
		}
	}
	
	// If the cell gets tapped
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let alert = UIAlertController(title: "Vector Actions", message: "What would you like to do to the vector?", preferredStyle: .alert)
		let unitize = UIAlertAction(title: "Unitize", style: .default) { _ in
			self.controller?.updateVector(at: indexPath.row, with: .length(val: 1))
			tableView.deselectRow(at: indexPath, animated: false)
			self.tableView.reloadRows(at: [indexPath], with: .none)
		}
		let normalize = UIAlertAction(title: "Normalize", style: .default) { _ in
			self.controller?.updateVector(at: indexPath.row, with: .normalize)
			tableView.deselectRow(at: indexPath, animated: false)
			self.tableView.reloadRows(at: [indexPath], with: .none)
		}
//		This is a feature that we have implemented, but are not using. Might add it in later
//		let move = UIAlertAction(title: "Move Vector", style: .default) { _ in
//			self.tableView.deselectRow(at: indexPath, animated: false)
//			if let newAlert = self.storyboard?.instantiateViewController(withIdentifier: "move") as? MoveVC{
//				newAlert.location = indexPath.row
//				newAlert.delegate = self.source
//				newAlert.modalTransitionStyle = .coverVertical
//				newAlert.modalPresentationStyle = .overCurrentContext
//				self.displayer?.present(newAlert, animated: true, completion: nil)
//			}
//		}
		let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
			tableView.deselectRow(at: indexPath, animated: false)
		}
		alert.addAction(unitize)
		alert.addAction(normalize)
//		alert.addAction(move)
		alert.addAction(cancel)
		self.displayer?.present(alert, animated: false, completion: nil)
	}
	
	// Updates the size of the cell depending on the orientation and screen
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let size: CGFloat
		if UIDevice.current.userInterfaceIdiom == .pad {
			if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
				size = UIScreen.main.bounds.height / 8
			} else {
				size = UIScreen.main.bounds.height / 6
			}
		} else {
			if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
				size = UIScreen.main.bounds.height / 5
			} else {
				size = UIScreen.main.bounds.height / 3
			}
		}
		return max(size, 175)
	}
	
	// Ends the text editing
	@objc func endEditing() {
		for cell in self.tableView.visibleCells where cell is VectorCell {
			let newCell = cell as! VectorCell
			newCell.angleField.endEditing(true)
			newCell.lengthField.endEditing(true)
			newCell.xField.endEditing(true)
			newCell.yField.endEditing(true)
		}
	}

	
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			self.controller?.removeVector(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
			if let cells = tableView.visibleCells as? [VectorCell] {
				for cell in cells {
					if let str = cell.xField.restorationIdentifier, let id = Int(str), id > indexPath.row {
						cell.xField.restorationIdentifier = "\(id - 1)"
						cell.yField.restorationIdentifier = "\(id - 1)"
						cell.angleField.restorationIdentifier = "\(id - 1)"
						cell.lengthField.restorationIdentifier = "\(id - 1)"
						cell.negateButton.restorationIdentifier = "\(id - 1)"
					}
				}
			}
        }
    }

}

extension InputController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return textField.endEditing(true)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if let id = textField.restorationIdentifier, let num = Int(id), let type = textField.accessibilityIdentifier, let value = CGFloat.convert(str: textField.text!) {
			if type == "x" {
				self.controller?.updateVector(at: num, with: .x(val: Decimal(value)))
			} else if type == "angle" {
				self.controller?.updateVector(at: num, with: .angle(val: Decimal(value)))
			} else if type == "length" {
				self.controller?.updateVector(at: num, with: .length(val: Decimal(value)))
			} else if type == "y" {
				self.controller?.updateVector(at: num, with: .y(val: Decimal(value)))
			}
			if let cell = self.tableView.cellForRow(at: IndexPath(item: num, section: 0)) as? VectorCell{
				self.controller?.updateCell(at: num, cell: cell)
			}
		}
	}
}

extension InputController: TransformationDelegate {
	// Perform a transformation
	func perform(transform: CGAffineTransform) {
		var count: CGFloat = 0
		let difference = (.identity - transform) / 50
		Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {timer in
			if count == 50 {
				self.source?.finishTransform(with: transform)
				self.tableView.reloadData()
				timer.invalidate()
				return
			}
			count += 1
			self.source?.partialTransform(with: (.identity - (difference * count)).invertY)
			self.tableView.reloadData()
		}
	}
}

extension CGAffineTransform {
	static func + (lhs: CGAffineTransform, rhs: CGAffineTransform) -> CGAffineTransform {
		return CGAffineTransform(a: lhs.a + rhs.a, b: lhs.b - rhs.b, c: lhs.c - rhs.c, d: lhs.d + rhs.d, tx: lhs.tx + rhs.tx, ty: lhs.ty + rhs.ty)
	}
	
	static func / (lhs: CGAffineTransform, rhs: CGFloat) -> CGAffineTransform {
		return CGAffineTransform(a: lhs.a / rhs, b: lhs.b / rhs, c: lhs.c / rhs, d: lhs.d / rhs, tx: lhs.tx / rhs, ty: lhs.ty / rhs)
	}
	
	static func - (lhs: CGAffineTransform, rhs: CGAffineTransform) -> CGAffineTransform {
		return CGAffineTransform(a: lhs.a - rhs.a, b: lhs.b + rhs.b, c: lhs.c + rhs.c, d: lhs.d - rhs.d, tx: lhs.tx - rhs.tx, ty: lhs.ty - rhs.ty)
	}
	
	static func * (lhs: CGAffineTransform, rhs: CGFloat) -> CGAffineTransform {
		return CGAffineTransform(a: lhs.a * rhs, b: lhs.b * rhs, c: lhs.c * rhs, d: lhs.d * rhs, tx: lhs.tx * rhs, ty: lhs.ty * rhs)
	}
	
	var invertY: CGAffineTransform {
		return CGAffineTransform(a: self.a, b: -self.b, c: -self.c, d: self.d, tx: self.tx, ty: self.ty)
	}
}

extension Decimal {
	init(_ float: CGFloat) {
		self.init(Double(float))
	}
}
