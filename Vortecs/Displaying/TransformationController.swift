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
	}
	
	@IBAction func applyTransform(_ sender: Any) {
		let transform = CGAffineTransform(a: CGFloat(x0.text!), b: CGFloat(y1.text!), c: CGFloat(x1.text!), d: CGFloat(y2.text!), tx: 0, ty: 0)
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
	init(_ string: String) {
		self.init(Double(string) ?? 0)
	}
}
