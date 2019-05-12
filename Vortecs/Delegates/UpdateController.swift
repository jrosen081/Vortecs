//
//  UpdateController.swift
//  Vortecs
//
//  Created by Jack Rosen on 5/7/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation

/// A data that deals with updating data from the table view
protocol UpdateController: class {
	/// Updates a vector at the index given
	/// - Parameters:
	///   - idx: The index of the vector
	///   - update: The update to perform
	func updateVector(at idx: Int, with update: Update)
	
	/// Updates the cell at the index
	/// - Parameters:
	///   - idx: The index of the vector
	///   - cell: The cell to update
	func updateCell(at idx: Int, cell: VectorCell)
	
	
	/// Removes the cell at the given index
	/// - Parameter idx: The index of the vector to remove
	func removeVector(at idx: Int)
}
