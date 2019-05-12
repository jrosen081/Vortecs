//
//  VectorData.swift
//  Vortecs
//
//  Created by Jack Rosen on 5/7/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

class VectorData: NSObject, VectorDelegate {
	private var vectors: [Vector]
	private var transform: CGAffineTransform
	private var undoes = [PreviousState]()
	
	var totalVectors: Int {
		return self.vectors.count
	}
	
	override convenience init() {
		self.init(vectors: [], transform: .identity)
	}
	
	init(vectors: [Vector], transform: CGAffineTransform) {
		self.vectors = vectors
		self.transform = transform
	}
	
	/// Gets the vector at a given index applying the transformation
	/// - Parameter idx: The index of the vector
	/// - returns: The vector at the given index
	private func vector(at idx: Int) -> Vector{
		return self.vectors[idx].transformed(with: self.transform)
	}
	
	
	func updateVector(at idx: Int, with update: Update) {
		if idx < vectors.count {
			undoes.append(PreviousState(vectors: self.vectors, transformation: self.transform))
			self.vectors[idx] = self.vector(at: idx).update(with: update)
		}
	}
	
	func fillInCellDetails(at idx: Int, cell: VectorCell) -> VectorCell {
		let vec = self.vector(at: idx)
		vec.updateCellValue(cell: cell)
		cell.border = (vec.color.cgColor, 1)
		cell.negateButton.backgroundColor = vec.color
		return cell
	}
	
	func allPaths() -> [(UIBezierPath, UIColor)] {
		return (0..<vectors.count).map({self.vector(at: $0).path()})
	}
	
	func apply(_ transform: CGAffineTransform, isFinished: Bool) {
		if isFinished {
			self.undoes.append(PreviousState(vectors: self.vectors, transformation: self.transform))
			self.transform = .identity
			self.vectors = self.vectors.map({$0.transformed(with: transform)})
		} else {
			self.transform = transform
		}
	}
	
	func addVector() {
		self.undoes.append(PreviousState(vectors: self.vectors, transformation: self.transform))
		self.vectors.append(CartesianVector.zero)
	}
	
	func removeVector(at idx: Int) {
		if idx < self.vectors.count {
			self.undoes.append(PreviousState(vectors: self.vectors, transformation: self.transform))
			self.vectors.remove(at: idx)
		}
	}
	
	func undo() {
		if !self.undoes.isEmpty {
			let state = self.undoes.popLast()!
			self.vectors = state.vectors
			self.transform = state.transformation
		}
	}
	
}
