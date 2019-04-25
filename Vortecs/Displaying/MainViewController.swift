//
//  ViewController.swift
//  VectorDisplayer
//
//  Created by Jack Rosen (New User) on 2/25/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	@IBOutlet weak var undoStack: UIStackView!
	var dataSource: VectorInteractor!
	var tableView: InputController! = nil
	var plane: Plane!
	@IBOutlet weak var undoButton: UIButton!
	@IBOutlet weak var createVectorsButton: UIButton!
	@IBOutlet weak var equalWidths: NSLayoutConstraint!
	@IBOutlet weak var planeHolder: UIScrollView!
	@IBOutlet weak var tableViewHolder: UIView!
	@IBOutlet weak var outsideStackView: UIStackView!
	@IBOutlet weak var internalStackView: UIStackView!
	@IBOutlet weak var horizontalCostraint: NSLayoutConstraint!
	@IBOutlet weak var verticalConstraint: NSLayoutConstraint!
	@IBOutlet weak var fixCoordinates: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dataSource  = VectorSource(undoManager: self, fixManager: self)
		if let view = storyboard?.instantiateViewController(withIdentifier: "TableView") as? InputController {
			self.tableView = view
			tableView.source = self.dataSource
			tableView.modalPresentationStyle = .overCurrentContext
			tableView.tableView.frame = tableViewHolder.bounds
			self.tableViewHolder.addSubview(tableView.tableView)
			self.planeHolder.delegate = self
			self.planeHolder.minimumZoomScale = 1
			self.planeHolder.maximumZoomScale = 3
			self.planeHolder.bouncesZoom = false
			self.tableView.displayer = self
			self.fixCoordinates.isHidden = true
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		self.makeUndoAvailable(available: false)
		plane = Plane(frame: self.planeHolder.bounds.doubled)
		self.planeHolder.addSubview(plane)
		self.planeHolder.contentSize = self.plane.bounds.size
		self.planeHolder.setContentOffset(CGPoint(x: self.plane.bounds.width / 4, y: self.plane.bounds.height / 4), animated: false)
		self.plane.startGrid()
		self.dataSource.draw(on: plane)
		self.plane.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapped)))
		self.plane.parent = self
		let gesture = UITapGestureRecognizer(target: self, action: #selector(self.center))
		gesture.numberOfTapsRequired = 2
		self.plane.addGestureRecognizer(gesture)
	}
	
	// This gets called when someone clicks on the plane
	@objc func tapped() {
		self.tableView.endEditing()
	}
	
	// Centers the view
	@objc func center() {
		UIView.animate(withDuration: 0.1) {
			self.planeHolder.setContentOffset(CGPoint(x: self.plane.frame.midX - self.planeHolder.frame.width / 2, y: self.plane.frame.midY - self.planeHolder.frame.height / 2), animated: false)
		}
	}
	
	// Sets up the stack view when it gets moved
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.setUpStackView(view: outsideStackView)
	}
	
	// Redraws all of the vectors
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
			self.plane.frame = self.planeHolder.bounds.doubled
			self.center()
			self.dataSource.redrawGrid()
			self.dataSource.drawAllVectors()
			self.makeUndoAvailable(available: self.dataSource.canUndo)
		}
	}
	
	// Sets up the stack view when the view changes
	override func updateViewConstraints() {
		super.updateViewConstraints()
		self.setUpStackView(view: self.outsideStackView)
	}
	
	// Sets up the stack view based on the orientation
	func setUpStackView(view: UIStackView) {
		if self.view.bounds.width > self.view.bounds.height {
			view.axis = .horizontal
			self.verticalConstraint.constant = 0
			if UIDevice.current.userInterfaceIdiom == .pad {
				self.horizontalCostraint.constant = (self.planeHolder.frame.width / 2)
			} else {
				self.horizontalCostraint.constant = (self.planeHolder.frame.width / 3)
			}
			
		} else {
			view.axis = .vertical
			self.horizontalCostraint.constant = 0
			if UIDevice.current.userInterfaceIdiom == .pad {
				self.verticalConstraint.constant = (self.planeHolder.frame.width / 2)
			} else {
				self.verticalConstraint.constant = (self.planeHolder.frame.width / 3)
			}
		}
	}
	
	@IBAction func createVector(_ sender: Any) {
		self.dataSource.addVector()
		self.tableView.tableView.reloadData()
	}
	@IBAction func undo(_ sender: Any) {
		self.plane.frame = CGRect(x: 0, y: 0, width: self.planeHolder.frame.width * 2 * self.planeHolder.zoomScale, height: self.planeHolder.frame.height * 2 * self.planeHolder.zoomScale)
		self.dataSource.undo()
		self.tableView.tableView.reloadData()
	}
	@IBAction func fixCoordinates(_ sender: Any) {
		self.plane.frame = CGRect(x: 0, y: 0, width: self.planeHolder.frame.width * 2 * self.planeHolder.zoomScale, height: self.planeHolder.frame.height * 2 * self.planeHolder.zoomScale)
		self.dataSource.fixCoordinates()
	}
	@IBAction func setUpTransformation(_ sender: Any) {
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "transformation") as? TransformationController {
			controller.delegate = self.tableView
			controller.modalTransitionStyle = .coverVertical
			controller.modalPresentationStyle = .overCurrentContext
			self.present(controller, animated: true)
		}
	}
}

extension MainViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return self.plane
	}
}

extension MainViewController: UndoDelegate {
	// Gives the option to undo something
	func makeUndoAvailable(available: Bool) {
		self.undoButton.isHidden = !available
	}
}

extension MainViewController: CoordinateDelegate {
	// Allows the coordinates to be fixed
	func allowFix(_ allowed: Bool) {
		self.fixCoordinates.isHidden = !allowed
	}
}

extension MainViewController: HoldingView {
	// Updates the content area of the planeHolder
	func updateHolder(with size: CGSize) {
		self.planeHolder.contentSize = size * self.planeHolder.zoomScale
		self.plane.frame = CGRect(x: 0, y: 0, width: size.width * self.planeHolder.zoomScale, height: size.height * self.planeHolder.zoomScale)
		self.center()
		self.planeHolder.isScrollEnabled = !(size < self.planeHolder.frame.size)
	}
}

extension CGRect {
	// Doubles the size while keeping the center
	var doubled: CGRect {
		return CGRect(x: 0, y: 0, width: self.width * 2, height: self.height * 2)
	}
}

extension CGSize {
	static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
		return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
	}
	
	static func < (lhs: CGSize, rhs: CGSize) -> Bool {
		return lhs.width < rhs.width || lhs.height < rhs.height
	}
}

