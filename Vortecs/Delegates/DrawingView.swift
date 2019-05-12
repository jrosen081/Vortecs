//
//  DrawingView.swift
//  Vortecs
//
//  Created by Jack Rosen on 5/7/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

/// A data object to draw objects
protocol DrawingView {
	/// Draws the given vectors with the given transform
	/// - Parameters:
	///   - vectors: An array of Paths with colors for the vectors
	///   - matrixTransformation: The transformation of the plane
	///   - cameraInfo: The camera object that shows the scale and pan
	func draw(vectors: [(UIBezierPath, UIColor)], matrixTransformation: CGAffineTransform, cameraInfo: Camera)
}
