//
//  VectorInteractor.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/5/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

protocol VectorInteractor: class {
	// Gets the vector at the given index
	func vector(at index: Int) -> Vector
	
	// Total vectors
	var totalVectors: Int {get}
	
	// Adds a vector to the list of vectors
	// EFFECT: Adds a vector to the list of vectors
	func addVector()
	
	// Removes a vector at the given index
	// EFFECT: Lowers the size of the vectors
	func removeVector(at index: Int)
	
	// Updates the vector at the index with an update
	// EFFECT: Updates the vector
	func updateVector(at index: Int, with update: Update)
	
	// Gives what to draw on
	func draw(on layer: Drawable)
	
	// Redraws all vectors
	func drawAllVectors()
	
	// Transforms the vectors
	func finishTransform(with transform: CGAffineTransform)
	
	// Does a partial transform
	func partialTransform(with transform: CGAffineTransform)
	
	// Undoes an operation
	func undo()
	
	// Redraws the grid
	func redrawGrid()
	
	// Can this vector be undone
	var canUndo: Bool {get}
	
	// Fixes the coordinate system in the plane
	func fixCoordinates()
	
	// Updates cell values
	func updateCellValues(at index: Int, cell: VectorCell)
	
}
