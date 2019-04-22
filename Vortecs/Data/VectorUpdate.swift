//
//  VectorUpdate.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/5/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation

enum Update {
	case negate
	case x (val: Decimal)
	case y (val: Decimal)
	case length (val: Decimal)
	case angle (val: Decimal)
	case normalize
	case move(x: Decimal, y: Decimal)
}
