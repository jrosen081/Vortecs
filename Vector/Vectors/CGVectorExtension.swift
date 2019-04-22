//
//  CGVectorExtension.swift
//  VectorDisplayer
//
//  Created by Jack Rosen (New User) on 2/25/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

extension Double {
	// Converts the double to radians
	func toRadians() -> Double {
		return self * .pi / 180
	}
	
	// Converts the double to degrees
	func toDegrees() -> Double {
		return self * 180 / .pi
	}
}
