//
//  VectorSource.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/5/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

class VectorSource: NSObject, VectorInteractor {
	// The vectors for the program
	private var vectors: [Vector]
	
	// The drawing delegate
	private var drawingDelegate: Drawable?
	
	// The previous states of the vectors
	private var previous: [PreviousState]
	
	// The transform of the vectors
	private var transform: CGAffineTransform = .identity
	
	// The current inBetween state of transform
	private var inBetween: CGAffineTransform = .identity
	
	// The manager of undoes
	private var undoManager: UndoDelegate
	
	// The manager of fixing coordinates
	private var fixManager: CoordinateDelegate
	
	// Can this vector be undone
	private(set) var canUndo: Bool = false
	
	
	// Gets the total vector count
	var totalVectors: Int {
		return vectors.count
	}
	
	convenience init(undoManager: UndoDelegate, fixManager: CoordinateDelegate) {
		self.init(vectors: [], undoManager: undoManager, fixManager: fixManager)
	}
	
	init(vectors: [Vector], undoManager: UndoDelegate, fixManager: CoordinateDelegate) {
		self.vectors = vectors
		self.previous = []
		self.undoManager = undoManager
		self.fixManager = fixManager
	}
	
	// Gets the vector at the given index
	func vector(at index: Int) -> Vector {
		return vectors[index].transformed(with: inBetween.invertY)
	}
	
	// Adds a vector to the list of vectors
	// EFFECT: Adds a vector to the list of vectors
	func addVector() {
		let vector = CartesianVector.zero
		self.previous.append(PreviousState(vectors: self.vectors, transformation: transform))
		self.vectors.append(vector)
		let vPath = vector.path()
		let _ = self.drawingDelegate?.draw(path: vPath.0, with: vPath.1, at: self.vectors.count - 1, having: self.inBetween)
		self.allowRedo()
	}
	
	// Removes a vector at the given index
	// EFFECT: Lowers the size of the vector
	func removeVector(at index: Int) {
		self.previous.append(PreviousState(vectors: self.vectors, transformation: transform))
		if index < vectors.count {
			vectors.remove(at: index)
			self.drawingDelegate?.removePath(at: index)
		}
		self.allowRedo()
	}
	
	// Updates the vector at the index with an update
	// EFFECT: Updates the vector
	func updateVector(at index: Int, with update: Update) {
		if index < self.vectors.count {
			self.previous.append(PreviousState(vectors: self.vectors, transformation: self.transform))
			self.vectors[index] = self.vectors[index].update(with: update)
			let path = self.vectors[index].path()
			path.0.apply(self.inBetween)
			self.drawingDelegate?.draw(path: path.0, with: path.1, at: index, having: self.inBetween)
			self.allowRedo()
		}
	}
	
	// Gives what to draw on
	func draw(on layer: Drawable) {
		self.drawingDelegate = layer
	}
	
	// Redraws all vectors
	func drawAllVectors() {
		for idx in 0 ..< self.vectors.count {
			let vector = self.vectors[idx]
			let vPath = vector.path()
			let _ = self.drawingDelegate?.draw(path: vPath.0, with: vPath.1, at: idx, having: self.inBetween)
		}
	}
	
	// Undoes to the previous state (if possible)
	func undo() {
		if let last = self.previous.last {
			self.vectors = last.vectors
			self.transform = last.transformation
			self.drawingDelegate?.startGrid(with: self.transform)
			self.drawAllVectors()
			self.previous.removeLast()
			self.fixManager.allowFix(!last.transformation.isIdentity)
		}
		self.allowRedo()
	}
	
	// Transforms the vectors
	func finishTransform(with transform: CGAffineTransform) {
		self.previous.append(PreviousState(vectors: self.vectors, transformation: self.transform))
		self.fixManager.allowFix(true)
		self.allowRedo()
		self.drawingDelegate?.startGrid(with: self.transform.concatenating(transform.invertY))
		self.inBetween = .identity
		self.vectors = self.vectors.map({$0.transformed(with: transform)})
		self.transform = self.transform.concatenating(transform.invertY)
		self.drawAllVectors()
	}
	
	// Does a partial transform
	func partialTransform(with transform: CGAffineTransform) {
		self.inBetween = transform
		self.drawingDelegate?.updateGrid(with: self.transform.concatenating(transform))
		self.drawAllVectors()
	}
	
	// Redraws the grid
	func redrawGrid() {
		self.drawingDelegate?.startGrid(with: self.transform)
	}
	
	// Fixes the coordinate system in the plane
	func fixCoordinates() {
		self.previous.append(PreviousState(vectors: self.vectors, transformation: self.transform))
		self.transform = .identity
		self.drawingDelegate?.startGrid(with: self.transform)
		self.fixManager.allowFix(false)
		self.drawAllVectors()
	}
	
	// Tries to undo the operations
	private func allowRedo() {
		if self.previous.isEmpty == self.canUndo {
			self.canUndo = !self.previous.isEmpty
			self.undoManager.makeUndoAvailable(available: !self.previous.isEmpty)
		}
	}
}
