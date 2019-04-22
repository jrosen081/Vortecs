//
//  Plane.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/5/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import UIKit

class Plane: UIView, Drawable {
	
	weak var parent: HoldingView?
	
	// Starts the grid
	func startGrid(with transform: CGAffineTransform = .identity) {
		let (bottomPath, gridPath) = self.makeUpdatedGrid(with: transform)
		bottomPath.apply(CGAffineTransform(translationX: self.bounds.origin.x - gridPath.bounds.origin.x, y: self.bounds.origin.y - gridPath.bounds.origin.y))
		gridPath.apply(CGAffineTransform(translationX: self.bounds.origin.x - gridPath.bounds.origin.x, y: self.bounds.origin.y - gridPath.bounds.origin.y))
		let bottomLayer = CAShapeLayer()
		bottomLayer.path = bottomPath.cgPath
		bottomLayer.strokeColor = UIColor.black.cgColor
		bottomLayer.lineWidth = bottomPath.lineWidth
		
		let gridLayer = CAShapeLayer()
		gridLayer.path = gridPath.cgPath
		gridLayer.strokeColor = UIColor.black.cgColor
		gridLayer.lineWidth = gridPath.lineWidth
		if self.layer.sublayers == nil || self.layer.sublayers?.count == 0 {
			self.layer.addSublayer(bottomLayer)
			self.layer.addSublayer(gridLayer)
			self.layer.addSublayer(CALayer())
			self.layer.addSublayer(CALayer())
		} else {
			self.layer.insertSublayer(bottomLayer, at: UInt32(0))
			self.layer.insertSublayer(gridLayer, at: UInt32(1))
			self.layer.sublayers?[2].removeFromSuperlayer()
			self.layer.sublayers?[2].removeFromSuperlayer()
			self.layer.insertSublayer(CALayer(), at: UInt32(2))
			self.layer.insertSublayer(CALayer(), at: UInt32(3))
			self.layer.sublayers?[4].removeFromSuperlayer()
			self.layer.sublayers?[4].removeFromSuperlayer()
		}
		self.bounds = gridPath.bounds
		parent?.updateHolder(with: gridPath.bounds.size)
	}
	
	private func makeUpdatedGrid(with transform: CGAffineTransform) -> (UIBezierPath, UIBezierPath) {
		let rect = self.bounds
		let inBetweenPath = UIBezierPath()
		for xIdx in stride(from: rect.midX, to: rect.maxX, by: 10) {
			inBetweenPath.move(to: CGPoint(x: xIdx, y: 0))
			inBetweenPath.addLine(to: CGPoint(x: xIdx, y: rect.maxY))
		}
		for xIdx in stride(from: rect.midX, to: 0, by: -10) {
			inBetweenPath.move(to: CGPoint(x: xIdx, y: 0))
			inBetweenPath.addLine(to: CGPoint(x: xIdx, y: rect.maxY))
		}
		
		for yIdx in stride(from: rect.midY, to: rect.maxY, by: 10) {
			inBetweenPath.move(to: CGPoint(x: 0, y: yIdx))
			inBetweenPath.addLine(to: CGPoint(x: rect.maxX, y: yIdx))
		}
		for yIdx in stride(from: rect.midY, to: 0, by: -10) {
			inBetweenPath.move(to: CGPoint(x: 0, y: yIdx))
			inBetweenPath.addLine(to: CGPoint(x: rect.maxX, y: yIdx))
		}
		inBetweenPath.apply(transform)
		inBetweenPath.apply(CGAffineTransform(translationX: self.bounds.midX - inBetweenPath.bounds.midX, y: self.bounds.midY - inBetweenPath.bounds.midY))
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: rect.midX, y: 0))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
		path.move(to: CGPoint(x: 0, y: rect.midY))
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
		path.lineWidth = 4
		path.apply(transform)
		path.apply(CGAffineTransform(translationX: self.bounds.midX - path.bounds.midX, y: self.bounds.midY - path.bounds.midY))
		return (inBetweenPath, path)
	}
	
	// Updates the grid layers
	func updateGrid(with transform: CGAffineTransform = .identity) {
		let (bottomPath, gridPath) = self.makeUpdatedGrid(with: transform)
		let bottomLayer = CAShapeLayer()
		bottomLayer.path = bottomPath.cgPath
		bottomLayer.strokeColor = UIColor(red: 0 / 255, green: 9 / 255, blue: 183 / 255, alpha: 1).cgColor
		bottomLayer.lineWidth = bottomPath.lineWidth
		
		let gridLayer = CAShapeLayer()
		gridLayer.path = gridPath.cgPath
		gridLayer.strokeColor = UIColor(red: 0 / 255, green: 9 / 255, blue: 183 / 255, alpha: 1).cgColor
		gridLayer.lineWidth = gridPath.lineWidth
		if self.layer.sublayers?.count ?? 0 >= 4  {
			self.layer.insertSublayer(bottomLayer, at: UInt32(2))
			self.layer.insertSublayer(gridLayer, at: UInt32(3))
			self.layer.sublayers?[4].removeFromSuperlayer()
			self.layer.sublayers?[4].removeFromSuperlayer()
		}
	}
	
	// Draws the path at the given location
	func draw(path: UIBezierPath, with color: UIColor, at location: Int, having transform: CGAffineTransform) {
		let layer = CAShapeLayer()
		layer.path = self.scale(path: path, with: transform).cgPath
		layer.strokeColor = color.cgColor
		layer.lineCap = .round
		layer.lineWidth = 5
		if location + 4 < self.layer.sublayers?.count ?? 0 {
			self.layer.insertSublayer(layer, at: UInt32(location + 4))
			self.layer.sublayers?[location + 5].removeFromSuperlayer()
		} else {
			self.layer.addSublayer(layer)
		}
	}
	
	// Removes the sublayer from the given superlayer
	func removePath(at location: Int) {
		self.layer.sublayers?[location + 4].removeFromSuperlayer()
	}
	
	// Scales the path to the given Drawable
	private func scale(path: UIBezierPath, with transform: CGAffineTransform) -> UIBezierPath{
		let newPath = UIBezierPath(cgPath: path.cgPath)
		newPath.apply(CGAffineTransform(scaleX: 10, y: 10).concatenating(transform).concatenating(CGAffineTransform(translationX: self.bounds.midX, y: self.bounds.midY)))
		return newPath
	}

}
