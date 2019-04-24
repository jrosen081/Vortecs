//
//  VectorDisplayerTests.swift
//  VectorDisplayerTests
//
//  Created by Jack Rosen (New User) on 2/25/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import XCTest
@testable import Vortecs

class VectorDisplayerTests: XCTestCase {
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testToRadians(){
		XCTAssertTrue(45.0.toRadians() == .pi / 4)
		XCTAssertTrue(90.0.toRadians() == .pi / 2)
		XCTAssertTrue(135.0.toRadians() == 3 * .pi / 4)
	}
	
	func testVector() {
		let vector1: CartesianVector = CartesianVector(x: 9, y: 12)
		XCTAssertTrue(vector1.length == 15)
		let vector2 = CartesianVector(x: 1, y: 1)
		XCTAssertTrue(vector2.angle == Decimal(Double.pi / 4))
	}
	
	func testToDegrees() {
		XCTAssertTrue((.pi / 2).toDegrees() == 90)
		XCTAssertTrue((.pi / 4).toDegrees() == 45)
	}
    func testPerformanceExample() {
    }

}
