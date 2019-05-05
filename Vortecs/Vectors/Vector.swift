//
//  Vector.swift
//  VectorDisplayer
//
//  Created by Jack Rosen (New User) on 2/25/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

protocol Vector {
	/// The beginning x value
	var beginX: Decimal {get}
	/// The end y value
	var beginY: Decimal {get}
	///  The x value
	var endX: Decimal {get}
	/// The y value
	var endY: Decimal {get}
	/// The angle
	var angle: Decimal {get}
	/// The length
	var length: Decimal {get}
	
	/**
	 * Updates the value to be the opposite of the vector
	* - returns: The vector that is opposite
	 */
	func negate() -> Vector
	
	/// Updates and returns the new vector with the given update
	func update(with update: Update) -> Vector
	
	/// Creates a Path representing the vector at the given x and y
	func path() -> (UIBezierPath, UIColor)
	
	/// Gets the color
	var color: UIColor {get}
	
	/// Transforms the Vector for display
	func transformed(with transform: CGAffineTransform) -> Vector
	
	/// Fixes the cell with values
	func updateCellValue(cell: VectorCell)
}

extension Vector {
	
	/// Transforms the Vector for display
	func transformed(with transform: CGAffineTransform) -> Vector {
		let newXY = CGPoint(x: self.beginX.doubleValue, y: self.beginY.doubleValue).applying(transform)
		let newEndXY = CGPoint(x: self.endX.doubleValue, y: self.endY.doubleValue).applying(transform)
		return CartesianVector(x: Decimal(Double(newEndXY.x)), y: Decimal(Double(newEndXY.y)), color: self.color, beginX: Decimal(Double(newXY.x)), beginY: Decimal(Double(newXY.y)))
	}
	
	/// A Zero vector
	static var zero: Vector {
		return CartesianVector(x: 0, y: 0)
	}
	/**
     * Gets a normal vector to this one
     */
	var normalVector: Vector {
		return PolarVector(angle: self.angle + (Decimal(Double.pi) / 2), length: self.length, color: color, beginX: self.beginX, beginY: self.beginY)
	}
	
	/// Creates a Path representing the vector at the given x and y
	func path() -> (UIBezierPath, UIColor) {
		let vector = UIBezierPath()
		vector.move(to: CGPoint(x: self.beginX.doubleValue, y: -self.beginY.doubleValue))
		vector.addLine(to: CGPoint.zero + (self.endX, -self.endY))
		if (self.length != 0) {
			vector.move(to: CGPoint.zero + (self.endX, -self.endY))
			vector.addLine(to: vector.currentPoint + (Decimal(self.length.doubleValue / 8 * cos(self.angle.doubleValue + .pi - (.pi / 8))), Decimal(-self.length.doubleValue / 8 * sin(self.angle.doubleValue + .pi - (.pi / 8)))))
			vector.move(to: CGPoint.zero + (self.endX, -self.endY))
			vector.addLine(to: vector.currentPoint + (Decimal(self.length.doubleValue / 8 * cos(self.angle.doubleValue + .pi + (.pi / 8))), Decimal(-self.length.doubleValue / 8 * sin(self.angle.doubleValue + .pi + (.pi / 8)))))
			return (vector, self.color)
		}
		return (UIBezierPath(), UIColor.black)
	}
	
	/// Fixes the cell with values
	func updateCellValue(cell: VectorCell) {
		cell.angleField.text = self.angle.twoDigits
		cell.lengthField.text = self.length.twoDigits
		cell.xField.text = (self.endX - self.beginX).twoDigits
		cell.yField.text = (self.endY - self.beginY).twoDigits
	}
}

extension Decimal {
	/// Displays the value to be 2 decimal places
	var twoDigits: String {
		return String(format: "%.2f", self.doubleValue)
	}
}

