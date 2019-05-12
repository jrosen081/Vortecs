//
//  PlaneView.swift
//  Vortecs
//
//  Created by Jack Rosen on 5/7/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

class PlaneView: UIView, DrawingView {
	public static let MIN_DISTANCE: CGFloat = 5
	public static let MAX_DISTANCE: CGFloat = 10
	public static let MAX_SCALE: CGFloat = 10
	public static let MIN_SCALE: CGFloat = 1
	private var currentTransform = CGAffineTransform.identity
	private var vectorsToDraw = [(UIBezierPath, UIColor)]()
	private var currentCamera: Camera = Camera.center
	
	func draw(vectors: [(UIBezierPath, UIColor)], matrixTransformation: CGAffineTransform, cameraInfo: Camera) {
		self.currentTransform = matrixTransformation
		self.vectorsToDraw = vectors
		self.currentCamera = cameraInfo
		self.setNeedsDisplay()
	}
	
	
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
		let scale: CGFloat
		let internalScale: CGFloat
		if self.currentCamera.zoomScale < 1 {
			scale = 5 - 1 / self.currentCamera.zoomScale
			internalScale = 1 / pow(2, CGFloat(1 + Int((1 / self.currentCamera.zoomScale) / 4)))
		} else {
			scale = self.currentCamera.zoomScale
			internalScale = pow(2, CGFloat(Int(self.currentCamera.zoomScale / 4)))
		}
		let scaleRemainder = scale.positiveRemainder(with: 5)
		let gridInterval = scaleRemainder * PlaneView.MIN_DISTANCE + PlaneView.MIN_DISTANCE
		let shift = CGVector(dx: (self.currentCamera.xShift - self.bounds.width / 2).remainder(dividingBy: gridInterval * 5), dy: (self.currentCamera.yShift - self.bounds.height / 2).remainder(dividingBy: gridInterval * 5))
		
		self.drawMinorLines(shift: shift, interval: gridInterval)
		self.drawMajorLines(shift: shift, interval: gridInterval)
		self.drawAxisLines(shift: CGVector(dx: self.currentCamera.xShift, dy: self.currentCamera.yShift), interval: gridInterval)
		self.drawVectors(shift: CGVector(dx: self.currentCamera.xShift, dy: self.currentCamera.yShift), scale: gridInterval)
    }
	
	/// Draws the minor lines
	private func drawMinorLines(shift: CGVector, interval: CGFloat) {
		UIColor.lightGray.setStroke()
		let path = UIBezierPath()
		let NUMBER_OF_LINES: CGFloat = 150
		path.lineWidth = 0.5
		for row in stride(from: -NUMBER_OF_LINES * interval, to: NUMBER_OF_LINES * interval, by: interval) {
			var topVector: Vector = CartesianVector(x: Double(CGFloat(-NUMBER_OF_LINES * interval)), y: Double(row))
			topVector = topVector.transformed(with: self.currentTransform)
			var bottomVector: Vector = CartesianVector(x: Double(CGFloat(NUMBER_OF_LINES * interval)), y: Double(row))
			bottomVector = bottomVector.transformed(with: self.currentTransform)
			path.move(to: CGPoint(x: topVector.endX.doubleValue, y: topVector.endY.doubleValue))
			path.addLine(to: CGPoint(x: bottomVector.endX.doubleValue, y: bottomVector.endY.doubleValue))
			
			var leftVector: Vector = CartesianVector(x: Double(row), y: Double(CGFloat(-NUMBER_OF_LINES * interval)))
			leftVector = leftVector.transformed(with: self.currentTransform)
			var rightVector: Vector = CartesianVector(x: Double(row), y: Double(CGFloat(NUMBER_OF_LINES * interval)))
			rightVector = rightVector.transformed(with: self.currentTransform)
			path.move(to: CGPoint(x: leftVector.endX.doubleValue, y: leftVector.endY.doubleValue))
			path.addLine(to: CGPoint(x: rightVector.endX.doubleValue, y: rightVector.endY.doubleValue))
		}
		path.apply(CGAffineTransform(translationX: shift.dx, y: shift.dy))
		path.apply(CGAffineTransform(translationX: self.bounds.width / 2, y: self.bounds.height / 2))
		path.stroke()
	}
	
	/// Draws the major lines
	private func drawMajorLines(shift: CGVector, interval: CGFloat) {
		UIColor.darkGray.setStroke()
		let path = UIBezierPath()
		let NUMBER_OF_LINES: CGFloat = 150
		path.lineWidth = 1
		for row in stride(from: -NUMBER_OF_LINES * interval, to: NUMBER_OF_LINES * interval, by: interval * 5) {
			var topVector: Vector = CartesianVector(x: Double(CGFloat(-NUMBER_OF_LINES * interval)), y: Double(row))
			topVector = topVector.transformed(with: self.currentTransform)
			var bottomVector: Vector = CartesianVector(x: Double(CGFloat(NUMBER_OF_LINES * interval)), y: Double(row))
			bottomVector = bottomVector.transformed(with: self.currentTransform)
			path.move(to: CGPoint(x: topVector.endX.doubleValue, y: topVector.endY.doubleValue))
			path.addLine(to: CGPoint(x: bottomVector.endX.doubleValue, y: bottomVector.endY.doubleValue))
			
			var leftVector: Vector = CartesianVector(x: Double(row), y: Double(CGFloat(-NUMBER_OF_LINES * interval)))
			leftVector = leftVector.transformed(with: self.currentTransform)
			var rightVector: Vector = CartesianVector(x: Double(row), y: Double(CGFloat(NUMBER_OF_LINES * interval)))
			rightVector = rightVector.transformed(with: self.currentTransform)
			path.move(to: CGPoint(x: leftVector.endX.doubleValue, y: leftVector.endY.doubleValue))
			path.addLine(to: CGPoint(x: rightVector.endX.doubleValue, y: rightVector.endY.doubleValue))
		}
		path.apply(CGAffineTransform(translationX: shift.dx, y: shift.dy))
		path.apply(CGAffineTransform(translationX: self.bounds.width / 2, y: self.bounds.height / 2))
		path.stroke()
	}
	
	/// Draws the axis lines
	private func drawAxisLines(shift: CGVector, interval: CGFloat) {
		let NUMBER_OF_LINES: CGFloat = 150
		let path = UIBezierPath()
		UIColor.black.setStroke()
		path.lineWidth = 2.5
		var topVector: Vector = CartesianVector(x: 0, y: Double(-NUMBER_OF_LINES * interval))
		topVector = topVector.transformed(with: self.currentTransform)
		var bottomVector: Vector = CartesianVector(x: 0, y: Double(NUMBER_OF_LINES * interval))
		bottomVector = bottomVector.transformed(with: self.currentTransform)
		path.move(to: CGPoint(x: topVector.endX.doubleValue, y: topVector.endY.doubleValue))
		path.addLine(to: CGPoint(x: bottomVector.endX.doubleValue, y: bottomVector.endY.doubleValue))
		path.apply(CGAffineTransform(translationX: shift.dx, y: 0))
		path.stroke()
		path.removeAllPoints()
		var leftVector: Vector = CartesianVector(x: Double(-NUMBER_OF_LINES * interval), y: 0)
		leftVector = leftVector.transformed(with: self.currentTransform)
		var rightVector: Vector = CartesianVector(x: Double(NUMBER_OF_LINES * interval), y: 0)
		rightVector = rightVector.transformed(with: self.currentTransform)
		path.move(to: CGPoint(x: leftVector.endX.doubleValue, y: leftVector.endY.doubleValue))
		path.addLine(to: CGPoint(x: rightVector.endX.doubleValue, y: rightVector.endY.doubleValue))
		path.apply(CGAffineTransform(translationX: 0, y: shift.dy))
		path.stroke()
	}
	
	/// Draws the vectors
	private func drawVectors(shift: CGVector, scale: CGFloat) {
		self.vectorsToDraw.forEach({(path, color) in
			color.setStroke()
			path.lineWidth = 2
			path.apply(CGAffineTransform(scaleX: scale, y: scale))
			path.apply(CGAffineTransform(translationX: shift.dx, y: shift.dy))
			path.stroke()
		})
	}
}

extension CGFloat {
	/// Create a positive remainder
	func positiveRemainder(with num: CGFloat) -> CGFloat {
		let remainder = self.remainder(dividingBy: num)
		if remainder >= 0 {
			return remainder
		} else {
			return num + remainder
		}
	}
	
	/// Returns a negative remainder
	func negativeRemainder(with num: CGFloat) -> CGFloat {
		let remainder = self.remainder(dividingBy: num)
		if remainder > 0 {
			return -num + remainder
		} else {
			return remainder
		}
	}
}
