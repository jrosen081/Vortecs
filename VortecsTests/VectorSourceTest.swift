//
//  VectorSourceTest.swift
//  VortecsTests
//
//  Created by Jack Rosen on 4/25/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import XCTest
@testable import Vortecs

class VectorSourceTest: XCTestCase, UndoDelegate, CoordinateDelegate {

	var vectorSource: VectorInteractor!
	
	override func setUp() {
		self.vectorSource = VectorSource(undoManager: self, fixManager: self)
	}
	
	func testSource() {
		vectorSource.addVector()
		XCTAssertEqual(vectorSource.vector(at: 0).length, 0)
		XCTAssertEqual(vectorSource.vector(at: 0).beginX, vectorSource.vector(at: 0).endX)
		XCTAssertEqual(vectorSource.totalVectors, 1)
		XCTAssertEqual(vectorSource.canUndo, true)
	}
	
	func testChanging() {
		vectorSource.addVector()
		vectorSource.updateVector(at: 0, with: .x(val: 10))
		vectorSource.updateVector(at: 0, with: .y(val: 10))
		XCTAssertEqual(vectorSource.vector(at: 0).endY, 10)
		XCTAssertEqual(vectorSource.vector(at: 0).endX, 10)
		XCTAssertEqual(vectorSource.vector(at: 0).length, Decimal(hypot(Double(10), 10)))
		vectorSource.updateVector(at: 0, with: .negate)
		XCTAssertEqual(vectorSource.vector(at: 0).endX, -10)
		vectorSource.removeVector(at: 0)
		XCTAssertEqual(vectorSource.totalVectors, 0)
		vectorSource.undo()
		XCTAssertEqual(vectorSource.totalVectors, 1)
		XCTAssertEqual(vectorSource.vector(at: 0).endX, -10)
		vectorSource.undo()
		vectorSource.undo()
		vectorSource.undo()
		XCTAssertTrue(vectorSource.canUndo)
		vectorSource.undo()
		XCTAssertFalse(vectorSource.canUndo)
	}
	
	func testRemove() {
		self.vectorSource.addVector()
		self.vectorSource.addVector()
		self.vectorSource.addVector()
		self.vectorSource.updateVector(at: 2, with: .angle(val: 1))
	  	XCTAssertEqual(self.vectorSource.totalVectors, 3)
		XCTAssertEqual(self.vectorSource.canUndo, true)
		self.vectorSource.removeVector(at: 2)
		XCTAssertEqual(self.vectorSource.totalVectors, 2)
	}
	
	
	
	func makeUndoAvailable(available: Bool) {
		print("undo? \(available)")
	}
	
	func allowFix(_ allowed: Bool) {
		print("allow? \(allowed)")
	}
}
