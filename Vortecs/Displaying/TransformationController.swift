//
//  TransformationController.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/20/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import UIKit

class TransformationController: UIViewController , UITextFieldDelegate{
	@IBOutlet weak var x0: UITextField!
	@IBOutlet weak var x1: UITextField!
	@IBOutlet weak var y1: UITextField!
	@IBOutlet weak var y2: UITextField!
	
	weak var delegate: TransformationDelegate?
    
	override func viewDidLoad() {
		self.view.backgroundColor = UIColor.clear
		self.view.isOpaque = false
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stopText)))
	}
	
	@objc func stopText() {
		self.x0.endEditing(true)
		self.x1.endEditing(true)
		self.y1.endEditing(true)
		self.y2.endEditing(true)
	}
	
	@IBAction func applyTransform(_ sender: Any) {
		let transform = CGAffineTransform(a: CGFloat.convert(str: x0.text!) ?? 0, b: CGFloat.convert(str: y1.text!) ?? 0, c: CGFloat.convert(str: x1.text!) ?? 0, d: CGFloat.convert(str: y2.text!) ?? 0, tx: 0, ty: 0)
		self.dismiss(animated: true) {
			self.delegate?.perform(transform: transform)
		}
	}
	
	@IBAction func cancel(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return textField.endEditing(true)
	}

}

extension CGFloat {
	static func convert(str: String) -> CGFloat? {
		if let val = Parser.parse(string: str) {
			return CGFloat(val.doubleValue)
		} else {
			return nil
		}
	}
}

