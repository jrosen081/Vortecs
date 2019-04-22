//
//  Vector.swift
//  VectorDisplayer
//
//  Created by Jack Rosen (New User) on 2/25/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

struct CartesianVector: Vector {
	
	let beginX: Decimal
	
	let beginY: Decimal
	
	/**
	 * Gets the x value for the vector
     */
	let endX: Decimal
	/**
	* Gets the y value for the vector
	*/
	let endY: Decimal
	/**
	* Gets the angle for the vector
	*/
	let angle: Decimal
	/**
	* Gets the length for the vector
	*/
	let length: Decimal
	
	/**
	* Updates the value to be the opposite of the vector
	* - returns: The vector that is opposite
	*/
	public func negate() -> Vector {
		return CartesianVector(x: self.endX * -1, y: self.endY * -1, color: color, beginX: -self.beginX, beginY: -self.beginY)
	}
	
	// The color for this vector
	let color: UIColor
	
	// Updates and returns the new vector with the given update
	func update(with update: Update) -> Vector {
		switch update {
		case .negate:
			return self.negate()
		case .angle(let val):
			return PolarVector(angle: val, length: self.length, color: color, beginX: self.beginX, beginY: self.beginY)
		case .length(let val):
			return PolarVector(angle: self.angle, length: val, color: color, beginX: self.beginX, beginY: self.beginY)
		case .x(let val):
			return CartesianVector(x: val, y: self.endY,  color: color, beginX: self.beginX, beginY: self.beginY)
		case .y(let val):
			return CartesianVector(x: self.endX, y: val, color: color, beginX: self.beginX, beginY: self.beginY)
		case .normalize:
			return self.normalVector
		case .move(let x, let y):
			return CartesianVector(x: self.endX + x, y: self.endY + y, color: self.color, beginX: self.beginX + x, beginY: self.beginY + y)
		}
	}
	
	init(x: Double, y: Double) {
		self.init(x: Decimal(x), y: Decimal(y), color: UIColor(displayP3Red: CGFloat.random(in: 0.1 ..< 0.9), green: CGFloat.random(in: 0.1 ..< 0.9),  blue: CGFloat.random(in: 0.1 ..< 0.9), alpha: 1))
	}
	
	init(x: Decimal, y: Decimal, color: UIColor) {
		self.init(x: x, y: y, color: color, beginX: 0, beginY: 0)
	}
	
	init(x: Decimal, y: Decimal, color: UIColor, beginX: Decimal, beginY: Decimal) {
		self.endX = x
		self.endY = y
		self.angle = Decimal(atan2((y - beginY).doubleValue, (x - beginX).doubleValue)).normalize()
		self.length = Decimal(hypot((x - beginX).doubleValue, (y - beginY).doubleValue))
		self.color = color
		self.beginX = beginX
		self.beginY = beginY
	}
}

extension Decimal {
	var doubleValue: Double {
		return (self as NSDecimalNumber).doubleValue
	}
	
	// Calculates the angle between -pi and pi
	func normalize() -> Decimal {
		if self > Decimal(.pi) {
			return (self - Decimal(2 * .pi)).normalize()
		} else if self < (Decimal(-.pi)) {
			return (self + Decimal(2 * .pi)).normalize()
		} else {
			return self
		}
	}
}

extension CGPoint {
	static func + (lhs: CGPoint, rhs: (Decimal, Decimal)) -> CGPoint {
		return CGPoint(x: lhs.x + CGFloat(rhs.0.doubleValue), y: lhs.y + CGFloat(rhs.1.doubleValue))
	}
}
