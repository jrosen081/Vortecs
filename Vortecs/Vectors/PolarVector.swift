//
//  PolarVector.swift
//  VectorDisplayer
//
//  Created by Jack Rosen (New User) on 2/25/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

struct PolarVector: Vector {
	// The beginning X value
	let beginX: Decimal
	
	// The beginning Y value
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
	
	// The color used for this
	let color: UIColor
	
	/**
	* Updates the value to be the opposite of the vector
	* - returns: The vector that is opposite
	*/
	public func negate() -> Vector {
		return PolarVector(angle: (angle + Decimal(Double.pi)), length: length, color: color, beginX: -self.beginX, beginY: -self.beginY)
	}
	
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
			return CartesianVector(x: val, y: self.endY, color: color, beginX: self.beginX, beginY: self.beginY)
		case .y(let val):
			return CartesianVector(x: self.endX, y: val, color: color, beginX: self.beginX, beginY: self.beginY)
		case .normalize:
			return self.normalVector
		case .move(let x, let y):
			return PolarVector(angle: self.angle, length: self.length, color: self.color, beginX: self.beginX + x, beginY: self.beginY - y)
		}
	}
	
	init(angle: Double, length: Double) {
		self.init(angle: Decimal(angle), length: Decimal(length), color: UIColor(displayP3Red: CGFloat.random(in: 100...200) /  255, green: CGFloat.random(in: 100...200) / 255, blue: CGFloat.random(in: 100...200) / 255, alpha: 1))
	}
	
	init(angle: Decimal, length: Decimal, color: UIColor) {
		self.init(angle: angle, length: length, color: color, beginX: 0, beginY: 0)
	}
	
	init(angle: Decimal, length: Decimal, color: UIColor, beginX: Decimal, beginY: Decimal) {
		self.angle = angle.normalize()
		self.length = length
		self.beginY = beginY
		self.beginX = beginX
		self.endX = Decimal(cos(angle.doubleValue)) * self.length + self.beginX
		self.endY = Decimal(sin(angle.doubleValue)) * self.length + self.beginY
		self.color = color
	}
}
