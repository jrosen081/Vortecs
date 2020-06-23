//
//  VectorTester.swift
//  VortecsTests
//
//  Created by Jack Rosen on 5/1/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import XCTest
@testable import Vortecs

class VectorTester: XCTestCase {

	func testXUpdate() {
		let vector1 = CartesianVector(x: 0, y: 0)
		XCTAssertEqual(vector1.angle, 0)
		XCTAssertEqual(vector1.length, 0)
		XCTAssertEqual(vector1.endX, vector1.beginX)
		XCTAssertEqual(vector1.endY, vector1.beginY)
		let newVector = vector1.update(with: .x(val: 10))
		XCTAssertEqual(newVector.endX, 10)
		XCTAssertEqual(newVector.length, 10)
		XCTAssertEqual(newVector.angle, vector1.angle)
	}
	
	func testYUpdate()  {
		let vector1 = CartesianVector.zero
		let newVector = vector1.update(with: .y(val: 10))
		XCTAssertEqual(newVector.endX, newVector.beginX)
		XCTAssertEqual(newVector.endY, 10)
		XCTAssertEqual(newVector.beginY, 0)
		XCTAssertEqual(vector1.endY, 0)
	}
	
	func testAffineTransform() {
		let vector1 = CartesianVector.zero.update(with: .y(val: 1))
		let newVector = vector1.transformed(with: CGAffineTransform(scaleX: 2, y: 2))
		let newestVector = vector1.transformed(with: CGAffineTransform(scaleX: 2, y: 2))
		XCTAssertEqual(newVector.beginX, 0)
		XCTAssertEqual(newVector.beginY, 0)
		XCTAssertEqual(newVector.length, 2)
		XCTAssertEqual(newVector.endY, newestVector.endY)
	}
}
