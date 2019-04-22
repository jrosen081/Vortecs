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
	weak var displayer: UIViewController?
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: self.tableView.rowHeight / 10, right: 0)
		self.tableView.separatorStyle = .singleLine
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
    }

	// Returns the number of rows/vectors
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source?.totalVectors ?? 0
    }

	// Gets the scell from the data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "VectorCell") as? VectorCell{
			if let vector = source?.vector(at: indexPath.row){
				cell.xField.text = "\((vector.endX - vector.beginX).twoDigits)"
				cell.yField.text = "\((vector.endY - vector.beginY).twoDigits)"
				cell.angleField.text = "\(vector.angle.twoDigits)"
				cell.lengthField.text = "\(vector.length.twoDigits)"
				cell.xField.restorationIdentifier = "\(indexPath.row)"
				cell.yField.restorationIdentifier = "\(indexPath.row)"
				cell.angleField.restorationIdentifier = "\(indexPath.row)"
				cell.lengthField.restorationIdentifier = "\(indexPath.row)"
				cell.negateButton.restorationIdentifier = "\(indexPath.row)"
				cell.negateButton.addTarget(self, action: #selector(negateVector(_:)), for: .touchUpInside)
				cell.negateButton.backgroundColor = vector.color
				cell.xField.delegate = self
				cell.yField.delegate = self
				cell.angleField.delegate = self
				cell.lengthField.delegate = self
				cell.border = (vector.color.cgColor, 1)
        	return cell
			}
		}
		return UITableViewCell()
    }
	
	// If the cell gets tapped
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let alert = UIAlertController(title: "Vector Actions", message: "What would you like to do to the vector?", preferredStyle: .alert)
		let unitize = UIAlertAction(title: "Unitize", style: .default) { _ in
			self.source?.updateVector(at: indexPath.row, with: .length(val: 1))
			tableView.deselectRow(at: indexPath, animated: false)
			self.tableView.reloadRows(at: [indexPath], with: .none)
		}
		let normalize = UIAlertAction(title: "Normalize", style: .default) { _ in
			self.source?.updateVector(at: indexPath.row, with: .normalize)
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
		self.present(alert, animated: false, completion: nil)
	}
	
	// Updates the size of the cell depending on the orientation and screen
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if UIDevice.current.userInterfaceIdiom == .pad {
			if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
				return UIScreen.main.bounds.height / 8
			} else {
				return UIScreen.main.bounds.height / 6
			}
		} else {
			if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
				return UIScreen.main.bounds.height / 5
			} else {
				return UIScreen.main.bounds.height / 3
			}
		}
	}
	
	
	// Negates the vector that relates to the given button
	@objc func negateVector(_ sender: UIButton) {
		if let id = sender.restorationIdentifier, let index = Int(id) {
			self.source?.updateVector(at: index, with: .negate)
			self.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
		}
	}
	
	// Ends the text editing
	func endEditing() {
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
			self.source?.removeVector(at: indexPath.row)
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
		textField.endEditing(true)
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if let id = textField.restorationIdentifier, let num = Int(id), let type = textField.accessibilityIdentifier, let value = Double(textField.text!) {
			if type == "x" {
				self.source?.updateVector(at: num, with: .x(val: Decimal(value)))
			} else if type == "angle" {
				self.source?.updateVector(at: num, with: .angle(val: Decimal(value)))
			} else if type == "length" {
				self.source?.updateVector(at: num, with: .length(val: Decimal(value)))
			} else if type == "y" {
				self.source?.updateVector(at: num, with: .y(val: Decimal(value)))
			}
			self.tableView.reloadRows(at: [IndexPath(item: num, section: 0)], with: .none)
		}
	}
}

extension InputController: TransformationDelegate {
	// Perform a transformation
	func perform(transform: CGAffineTransform) {
		var count: CGFloat = 0
		let difference = (.identity - transform) / 60
		Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {timer in
			if count == 60 {
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
