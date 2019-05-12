//
//  VectorDelegate.swift
//  Vortecs
//
//  Created by Jack Rosen on 5/7/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

/// The Delegate that will be the sole way to interact with Vectors
protocol VectorDelegate {
	/// The total amount of vectors in the set
	var totalVectors: Int {get}
	/// Updates a vector at the given index
	/// - Parameters:
	///   - idx: The index of the vector to update
	///   - update: The given update to perform on the Vector
	func updateVector(at idx: Int, with update: Update)
	
	/// Updates the given cell at the given index with the vector values
	/// - Parameters:
	///   - idx: The index of the vector
	///   - cell: The cell to update
	/// - returns: The updated cell
	@discardableResult
	func fillInCellDetails(at idx: Int, cell: VectorCell) -> VectorCell
	
	/// Gets the paths of all of the vectors
	/// All of the paths are centered at (0,0)
	/// - returns: The list of all of the vector paths and their colors
	func allPaths() -> [(UIBezierPath, UIColor)]
	
	/// Performs a transform on the given vectors
	/// - Parameter transform: The transform to update all of the vectors
	/// - Parameter isFinished: Whether the transform is finished or not
	func apply(_ transform: CGAffineTransform, isFinished: Bool)
	
	/// Adds a (0, 0) vector to the vector supply
	func addVector()
	
	/// Removes a vector at a given index
	/// - Parameter idx: The index of the vector to be removed
	func removeVector(at idx: Int)
	
	/// Undoes the recent change
	func undo()
	
	
}
