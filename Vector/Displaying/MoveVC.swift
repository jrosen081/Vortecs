//
//  MoveVC.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/20/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import UIKit

class MoveVC: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var xMove: UITextField!
	@IBOutlet weak var yMove: UITextField!
	var delegate: VectorInteractor?
	var location = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.clear
		self.view.isOpaque = false
	}
	
	@IBAction func cancel(_ sender: Any) {
		self.dismiss(animated: true)
	}
	@IBAction func applyMovement(_ sender: Any) {
		self.dismiss(animated: true) {
			if let moveX = Decimal(string: self.xMove.text!), let moveY = Decimal(string: self.yMove.text!) {
				self.delegate?.updateVector(at: self.location, with: .move(x: moveX, y: moveY))
			}
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return textField.endEditing(true)
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
