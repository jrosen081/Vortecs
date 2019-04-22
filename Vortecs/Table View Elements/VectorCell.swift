//
//  VectorCell.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/5/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import UIKit

class VectorCell: UITableViewCell{
	@IBOutlet weak var xLabel: UILabel!
	@IBOutlet weak var xField: UITextField!
	@IBOutlet weak var yLabel: UILabel!
	@IBOutlet weak var yField: UITextField!
	@IBOutlet weak var lengthLabel: UILabel!
	@IBOutlet weak var lengthField: UITextField!
	@IBOutlet weak var angleLabel: UILabel!
	@IBOutlet weak var angleField: UITextField!
	@IBOutlet weak var negateButton: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		xField.accessibilityIdentifier = "x"
		yField.accessibilityIdentifier = "y"
		angleField.accessibilityIdentifier = "angle"
		lengthField.accessibilityIdentifier = "length"
		self.border = (UIColor.black.cgColor, 1)
    }
}

extension UIView {
	// Update the border color
	var border: (CGColor?, CGFloat) {
		get {
			return (self.layer.borderColor, self.layer.borderWidth)
		}
		set {
			self.layer.borderWidth = newValue.1
			self.layer.borderColor = newValue.0
		}
	}
}
