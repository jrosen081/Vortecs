//
//  TransformationDelegate.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/20/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

protocol TransformationDelegate: class {
	// Perform a transformation
	func perform(transform: CGAffineTransform)
}
