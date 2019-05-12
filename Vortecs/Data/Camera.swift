//
//  Camera.swift
//  Vortecs
//
//  Created by Jack Rosen on 5/7/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import Foundation
import UIKit

struct Camera {
	let xShift: CGFloat
	let yShift: CGFloat
	let zoomScale: CGFloat
	var normalizedZoomScale: CGFloat {
		return (zoomScale  - 1).positiveRemainder(with: 5) + 1
	}
	
	/// The transform representation
	var transform: CGAffineTransform {
		return CGAffineTransform(a: self.zoomScale * 10, b: 0, c: 0, d: -self.zoomScale * 10, tx: self.xShift, ty: self.yShift)
	}
	
	/// Centers the given camera object to the center of the plane
	/// - returns: The camera object being in the center
	func center() -> Camera {
		return Camera(xShift: 0, yShift: 0, zoomScale: self.zoomScale)
	}
	
	/// Pans the camera by the given increments
	/// - Parameters:
	///   - xShift: The shift in the x axis
	///   - yShift: The shift in the y axis
	/// - returns: The updated camera object
	func pan(xShift: CGFloat, yShift: CGFloat) -> Camera {
		return Camera(xShift: self.xShift + xShift, yShift: self.yShift + yShift, zoomScale: self.zoomScale)
	}
	
	/// Zooms the camera
	/// - Parameters:
	///   - scale: The scale to zoom by
	///   - returns: The updated camera object
	func zoom(by scale: CGFloat) -> Camera {
		let newScale = self.normalizedZoomScale * scale
		return Camera(xShift: self.xShift, yShift: self.yShift, zoomScale: self.zoomScale + newScale - self.normalizedZoomScale)
	}
}

extension Camera {
	static let center = Camera(xShift: 0, yShift: 0, zoomScale: 1)
}
