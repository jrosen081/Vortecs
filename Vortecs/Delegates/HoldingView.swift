//
//  HoldingView.swift
//  VectorDisplayer
//
//  Created by Jack Rosen on 4/21/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

protocol HoldingView: class {
	/// Updates the view of the contained view
	func updateHolder(with size: CGSize)
}
