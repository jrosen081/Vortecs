//
//  Plane.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/5/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import UIKit

class Plane: UIView, Drawable {
	override var translatesAutoresizingMaskIntoConstraints: Bool {
		get{return true}
		set{super.translatesAutoresizingMaskIntoConstraints = newValue}
	}
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		self.layer.speed = 2
	}
	
	weak var parent: HoldingView?
	private var startingBottomLayer: CAShapeLayer = CAShapeLayer()
	private var startingTopLayer: CAShapeLayer = CAShapeLayer()
	private var startingHoldingLayer = CAShapeLayer()
	private var startingHoldingTopLayer = CAShapeLayer()
	
	/// Starts the grid
	func startGrid(with transform: CGAffineTransform = .identity) {
		DispatchQueue.main.async {
			let (bottomPath, gridPath) = self.makeUpdatedGrid(with: transform)
			let (normalBottom, normalTop) = self.makeUpdatedGrid(with: .identity)
			let bottomTransform = CGAffineTransform(translationX: self.bounds.origin.x - gridPath.bounds.origin.x, y: self.bounds.origin.y - gridPath.bounds.origin.y)
			bottomPath.apply(bottomTransform)
			let topTransform = CGAffineTransform(translationX: self.bounds.origin.x - gridPath.bounds.origin.x, y: self.bounds.origin.y - gridPath.bounds.origin.y)
			gridPath.apply(topTransform)
			let bottomLayer = CAShapeLayer()
			bottomLayer.path = bottomPath.cgPath
			bottomLayer.strokeColor = UIColor.black.cgColor
			bottomLayer.lineWidth = bottomPath.lineWidth
			
			self.startingBottomLayer.lineWidth = 0
			self.startingBottomLayer.strokeColor = UIColor(red: 0 / 255, green: 9 / 255, blue: 183 / 255, alpha: 1).cgColor
			self.startingBottomLayer.path = normalBottom.cgPath
			self.startingBottomLayer.setAffineTransform(transform.concatenating(topTransform))
			self.startingHoldingLayer.lineWidth = bottomPath.lineWidth
			self.startingHoldingLayer.strokeColor = UIColor(red: 0 / 255, green: 9 / 255, blue: 183 / 255, alpha: 1).cgColor
			self.startingHoldingLayer.path = normalBottom.cgPath
			
			let gridLayer = CAShapeLayer()
			gridLayer.path = gridPath.cgPath
			gridLayer.strokeColor = UIColor.black.cgColor
			gridLayer.lineWidth = gridPath.lineWidth
			
			self.startingTopLayer.lineWidth = 0
			self.startingTopLayer.strokeColor = UIColor(red: 0 / 255, green: 9 / 255, blue: 183 / 255, alpha: 1).cgColor
			self.startingTopLayer.path = normalTop.cgPath
			self.startingTopLayer.setAffineTransform(transform.concatenating(topTransform))
			self.startingHoldingTopLayer.lineWidth = gridPath.lineWidth
			self.startingHoldingTopLayer.strokeColor = UIColor(red: 0 / 255, green: 9 / 255, blue: 183 / 255, alpha: 1).cgColor
			self.startingHoldingTopLayer.path = normalTop.cgPath
			if self.layer.sublayers == nil || self.layer.sublayers?.count == 0 {
				self.layer.addSublayer(bottomLayer)
				self.layer.addSublayer(gridLayer)
				self.layer.addSublayer(self.startingBottomLayer)
				self.layer.addSublayer(self.startingTopLayer)
			} else {
				if let bottomL = self.layer.sublayers?[0] as? CAShapeLayer, let gridL = self.layer.sublayers?[1] as? CAShapeLayer{
					bottomL.path = bottomPath.cgPath
					gridL.path = gridPath.cgPath
				}
			}
			self.bounds = gridPath.bounds
			self.parent?.updateHolder(with: gridPath.bounds.size)
		}
	}
	
	/// Makes the path for the two layers of the grid
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
	
	/// Updates the grid layers
	func updateGrid(with transform: CGAffineTransform = .identity) {
		DispatchQueue.main.async {
			CATransaction.begin()
			CATransaction.setDisableActions(true)
			let extraPath = UIBezierPath(cgPath: self.startingHoldingTopLayer.path!)
			extraPath.apply(transform)
			let translate = CGAffineTransform(translationX: self.bounds.midX - extraPath.bounds.midX, y: self.bounds.midY - extraPath.bounds.midY)
			let otherExtra = UIBezierPath(cgPath: self.startingHoldingLayer.path!)
			otherExtra.apply(transform)
			let otherTranslate = CGAffineTransform(translationX: self.bounds.midX - otherExtra.bounds.midX, y: self.bounds.midY - otherExtra.bounds.midY)
			self.startingBottomLayer.setAffineTransform(transform.concatenating(otherTranslate))
			self.startingTopLayer.setAffineTransform(transform.concatenating(translate))
			self.startingBottomLayer.lineWidth =  self.startingHoldingLayer.lineWidth
			self.startingTopLayer.lineWidth = self.startingHoldingTopLayer.lineWidth
			CATransaction.commit()
		}
	}
	
	/// Draws the path at the given location
	func draw(path: UIBezierPath, with color: UIColor, at location: Int, having transform: CGAffineTransform) {
		DispatchQueue.main.async {
			let layer = CAShapeLayer()
			layer.path = self.scale(path: path, with: transform).cgPath
			layer.lineWidth = 5
			layer.strokeColor = color.cgColor
			if location + 4 < self.layer.sublayers?.count ?? 0 {
				if let layer = self.layer.sublayers?[location + 4] as? CAShapeLayer {
					layer.path = self.scale(path: path, with: transform).cgPath
					layer.strokeColor = color.cgColor
				}
			} else {
				self.layer.addSublayer(layer)
			}
		}
	}
	
	/// Removes the sublayer from the given superlayer
	func removePath(at location: Int) {
		self.layer.sublayers?[location + 4].removeFromSuperlayer()
	}
	
	/// Scales the path to the given Drawable
	private func scale(path: UIBezierPath, with transform: CGAffineTransform) -> UIBezierPath{
		let newPath = UIBezierPath(cgPath: path.cgPath)
		newPath.apply(CGAffineTransform(scaleX: 10, y: 10).concatenating(transform).concatenating(CGAffineTransform(translationX: self.bounds.midX, y: self.bounds.midY)))
		return newPath
	}

}
