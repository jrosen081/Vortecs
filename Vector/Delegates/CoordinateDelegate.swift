//
//  CoordinateDelegate.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/21/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation

protocol CoordinateDelegate: class {
	// Allows the coordinates to be fixed
	func allowFix(_ allowed: Bool)
}
