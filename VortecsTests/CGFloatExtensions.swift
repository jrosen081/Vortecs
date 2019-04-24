//
//  CGFloatExtensions.swift
//  VortecsTests
//
//  Created by Jack Rosen on 4/22/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import XCTest
@testable import Vortecs

class CGFloatExtensions: XCTestCase {

	func testStringParsing() {
		let value = "0-0.24"
		XCTAssertNotNil(CGFloat.convert(str: "0.9"))
		XCTAssertNotNil(CGFloat.convert(str: value))
		XCTAssertEqual(CGFloat.convert(str: "0.9"), 0.9)
		XCTAssertEqual(CGFloat.convert(str: value), -0.24)
		XCTAssertNotNil(CGFloat.convert(str: "1 + 2"))
		XCTAssertEqual(CGFloat.convert(str: "1 + 2")!, 3)
		XCTAssertEqual(CGFloat.convert(str: "1 / 3 + 2"), 2 + 1 / 3)
		XCTAssertEqual(CGFloat.convert(str: "4 - 2 + 1"), 3)
		XCTAssertEqual(CGFloat.convert(str: "4 / 2 * 3"), 6)
		XCTAssertNil(CGFloat.convert(str: "4 / 3 * k"))
		XCTAssertEqual(CGFloat.convert(str: "4 * 12 / 3"), 16)
		XCTAssertEqual(CGFloat.convert(str: "4 + 19"), 23)
		XCTAssertEqual(CGFloat.convert(str: "4 - 19"), -15)
		XCTAssertEqual(CGFloat.convert(str: "2 * 10"), 20)
		XCTAssertEqual(CGFloat.convert(str: "4 / 2"), 2)
		XCTAssertEqual(CGFloat.convert(str: "-3"), -3)
		XCTAssertEqual(CGFloat.convert(str: "-3 * -4"), 12)
	}
}
