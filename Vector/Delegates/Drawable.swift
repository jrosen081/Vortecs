//
//  Drawable.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/5/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

protocol Drawable {
	// Draws the path at the given location
	func draw(path: UIBezierPath, with color: UIColor, at location: Int, having transform: CGAffineTransform) 
	
	// Removes the sublayer from the given superlayer
	func removePath(at location: Int)
	
	// Fixes up the grid
	func updateGrid(with transform: CGAffineTransform)
	
	// Starts the grid
	func startGrid(with transform: CGAffineTransform)
}
