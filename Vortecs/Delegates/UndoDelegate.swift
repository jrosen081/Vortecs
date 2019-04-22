//
//  UndoDelegate.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/18/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation

protocol UndoDelegate {
	// Gives the option to undo something
	func makeUndoAvailable(available: Bool)
}
