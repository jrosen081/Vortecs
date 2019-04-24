//
//  StringToDecimal.swift
//  Vortecs
//
//  Created by Jack Rosen on 4/23/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation

struct Parser {
	static func parse(string: String) -> Decimal? {
		let updatedString = Parser.changeMinusIntoOther(string: string)
		guard updatedString.contains("/") || updatedString.contains("*") || updatedString.contains("+") || updatedString.contains("-") || Decimal(string: string) != nil else {
			return nil
		}
		if updatedString.contains("+") || updatedString.contains("-") {
			let addAll = updatedString.split(separator: "+").map(String.init)
			let subMids = addAll.map({string in string.split(separator: "-").map(String.init)})
			return subMids.reduce(0, {(result, next) in
				if let res = result {
					if let first = next.first {
						return res +++ next.dropFirst().reduce(Parser.parse(string: first.replacingOccurrences(of: "~", with: "-")), { (insideResult: Decimal?, unParsed: String) -> Decimal? in
							if let val = insideResult, let nextVal = Parser.parse(string: unParsed.replacingOccurrences(of: "~", with: "-")){
								return val - nextVal
							} else {
								return nil
							}
						})
					} else {
						return res
					}
				} else {
					return nil
				}
			})
		} else if updatedString.contains("*") || updatedString.contains("/") {
			let multAll = updatedString.split(separator: "*").map(String.init)
			let divMids = multAll.map({string in string.split(separator: "/").map(String.init)})
			return divMids.reduce(1, {(result, next) in
				if let res = result {
					if let first = next.first {
						return res ** next.dropFirst().reduce(Parser.parse(string: first.replacingOccurrences(of: "~", with: "-")), { (insideResult: Decimal?, unParsed: String) -> Decimal? in
							if let val = insideResult, let nextVal = Parser.parse(string: unParsed.replacingOccurrences(of: "~", with: "-")), nextVal != 0{
								return val / nextVal
							} else {
								return nil
							}
						})
					} else {
						return nil
					}
				} else {
					return nil
				}
			})
		} else {
			return Decimal(string: string)!
		}
	}
	
	static func changeMinusIntoOther(string: String) -> String {
		var newString = ""
		for char in string {
			if String(char) == "-" && !newString.endsWithNum() {
				newString += "~"
			} else {
				newString += String(char)
			}
		}
		return newString
	}
}

extension Decimal {
	static func +++ (lhs: Decimal, rhs: Decimal?) -> Decimal? {
		if let r = rhs {
			return r + lhs
		} else {
			return nil
		}
	}
	
	static func ** (lhs: Decimal, rhs: Decimal?)  -> Decimal? {
		if let r = rhs {
			return r * lhs
		} else {
			return nil
		}
	}
}

extension String {
	func endsWithNum() -> Bool {
		let val = self.trimmingCharacters(in: .whitespaces)
		if let lastVal = val.last {
			return Float(String(lastVal)) != nil
		} else {
			return false
		}
	}
}
infix operator +++
infix operator **
