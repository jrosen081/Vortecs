//
//  SelectorHolder.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/20/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation

class SelectorHolder {
	let closure: () -> ()
	
	init(closure: @escaping () -> ()) {
		self.closure = closure
	}
	
	// Apply closure
	@objc func apply(){
		closure()
	}
}
