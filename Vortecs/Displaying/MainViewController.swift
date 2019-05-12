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
	var tableView: InputController! = nil
	private let source: VectorDelegate = VectorData()
	@IBOutlet weak var undoButton: UIButton!
	@IBOutlet weak var createVectorsButton: UIButton!
	@IBOutlet weak var equalWidths: NSLayoutConstraint!
	
	@IBOutlet weak var planeView: PlaneView!
	@IBOutlet weak var tableViewHolder: UIView!
	@IBOutlet weak var outsideStackView: UIStackView!
	@IBOutlet weak var internalStackView: UIStackView!
	@IBOutlet weak var horizontalCostraint: NSLayoutConstraint!
	@IBOutlet weak var verticalConstraint: NSLayoutConstraint!
	@IBOutlet weak var fixCoordinates: UIButton!
	@IBOutlet weak var applyTransform: UIButton!
	@IBOutlet weak var centralTopView: UIView!
	@IBOutlet weak var centralBottomView: UIView!
	private var transformation = CGAffineTransform.identity
	private var previousStates = [PreviousState]()
	private var pointToZoomAround = CGPoint.zero
	private var currentCamera: Camera  = .center {
		didSet {
			self.planeView.draw(vectors: self.source.allPaths(), matrixTransformation: self.transformation, cameraInfo: self.currentCamera)
		}
	}
	
	private var currentLocationOfPan = CGPoint.zero
	
	// Sets up the data and the table view.
	override func viewDidLoad() {
		super.viewDidLoad()
		if let view = storyboard?.instantiateViewController(withIdentifier: "TableView") as? InputController {
			self.tableView = view
			tableView.modalPresentationStyle = .overCurrentContext
			tableView.tableView.frame = tableViewHolder.bounds
			self.tableViewHolder.addSubview(tableView.tableView)
			self.tableView.displayer = self
			self.fixCoordinates.isHidden = true
			self.createVectorsButton.layer.cornerRadius = 5
			self.undoButton.layer.cornerRadius = 5
			self.fixCoordinates.layer.cornerRadius = 5
			self.applyTransform.layer.cornerRadius = 5
			self.centralTopView.isHidden = true
			self.centralBottomView.isHidden = true
			self.tableView.controller = self
			self.tableView.tableView.dataSource = self
		}
	}
	
	// Sets up the plane to be the correct size
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.makeUndoAvailable(available: false)
		self.setUpStackView(view: self.outsideStackView)
		let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
		self.planeView.addGestureRecognizer(pan)
		let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.center(_:)))
		doubleTap.numberOfTapsRequired = 2
		self.planeView.addGestureRecognizer(doubleTap)
		let zoom = UIPinchGestureRecognizer(target: self, action: #selector(self.zoom(_:)))
		self.planeView.addGestureRecognizer(zoom)
		let ridKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
		ridKeyboard.numberOfTapsRequired = 1
		self.planeView.addGestureRecognizer(ridKeyboard)
		self.currentCamera = self.currentCamera.pan(xShift: self.planeView.bounds.width / 2, yShift: self.planeView.bounds.height / 2)
	}
	
	// This gets called when someone clicks on the plane
	@objc func tapped() {
		self.tableView.endEditing()
	}
	
	// Centers the view
	@objc func center(_ sender: Any = true) {
		self.currentCamera = currentCamera.center().pan(xShift: self.planeView.bounds.width / 2, yShift: self.planeView.bounds.height / 2)
	}
	
	/// Zooms the scale from the given point
	@objc func zoom(_ sender: UIPinchGestureRecognizer) {
		guard sender.numberOfTouches > 1 else {return}
		let location = sender.location(ofTouch: 0, in: self.planeView).midPoint(with: sender.location(ofTouch: 1, in: self.planeView)).applying(CGAffineTransform(translationX: -(self.currentCamera.xShift / self.currentCamera.zoomScale), y: -self.currentCamera.yShift / self.currentCamera.zoomScale))
		if sender.state == .began {
			self.pointToZoomAround = location
		}
		let scale = sender.scale
		sender.scale = 1
		let newLocation = CGPoint(x: self.pointToZoomAround.x * (scale - 1), y: self.pointToZoomAround.y * (scale - 1))
		let inBetweenCamera = self.currentCamera.zoom(by: scale)
		self.currentCamera = inBetweenCamera.pan(xShift: -newLocation.x, yShift: -newLocation.y)
		//self.currentCamera = inBetweenCamera.pan(xShift: (self.pointToZoomAround.x - newLocation.x), yShift: (self.pointToZoomAround.y - newLocation.y))
		self.pointToZoomAround = CGPoint(x: self.pointToZoomAround.x + newLocation.x, y: self.pointToZoomAround.y + newLocation.y)
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
			self.center()
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
				self.horizontalCostraint.constant = (self.view.frame.width / 8)
			} else {
				self.horizontalCostraint.constant = (self.view.frame.width / 10)
			}
			
		} else {
			view.axis = .vertical
			self.horizontalCostraint.constant = 0
			if UIDevice.current.userInterfaceIdiom == .pad {
				self.verticalConstraint.constant = -(self.view.frame.height / 2)
			} else {
				self.verticalConstraint.constant = -(self.view.frame.height / 3)
			}
		}
	}
	
	@IBAction func createVector(_ sender: Any) {
		self.source.addVector()
		self.tableView.tableView.reloadData()
		self.currentCamera = self.currentCamera.pan(xShift: 0, yShift: 0)
		self.makeUndoAvailable(available: true)
	}
	@IBAction func undo(_ sender: Any) {
		self.source.undo()
		self.tableView.tableView.reloadData()
		self.currentCamera = self.currentCamera.pan(xShift: 0, yShift: 0)
	}
	@IBAction func fixCoordinates(_ sender: Any) {
		self.makeUndoAvailable(available: true)
		self.currentCamera = self.currentCamera.center()
	}
	@IBAction func setUpTransformation(_ sender: Any) {
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "transformation") as? TransformationController {
			controller.delegate = self.tableView
			controller.modalTransitionStyle = .coverVertical
			controller.modalPresentationStyle = .overCurrentContext
			self.present(controller, animated: true)
		}
	}
	
	// Negates the vector that relates to the given button
	@objc func negateVector(_ sender: UIButton) {
		if let id = sender.restorationIdentifier, let index = Int(id) {
			self.source.updateVector(at: index, with: .negate)
			self.tableView.updateCell(at: index)
			self.currentCamera = self.currentCamera.pan(xShift: 0, yShift: 0)
		}
	}
	
	/// Updates the panning of the vectors
	@objc func pan(_ sender: UIPanGestureRecognizer) {
		if sender.state == .began {
			self.currentCamera = self.currentCamera.pan(xShift: sender.translation(in: self.view).x, yShift: -sender.translation(in: self.view).y)
			self.currentLocationOfPan = sender.location(in: self.view)
		} else {
			self.currentCamera = self.currentCamera.pan(xShift: sender.location(in: self.view).x - self.currentLocationOfPan.x, yShift: sender.location(in: self.view).y - self.currentLocationOfPan.y)
			self.currentLocationOfPan = sender.location(in: self.view)
		}
	}
}

extension MainViewController: UndoDelegate {
	// Gives the option to undo something
	func makeUndoAvailable(available: Bool) {
		self.undoButton.isHidden = !available
		self.centralTopView.isHidden = !available
	}
}

extension MainViewController: CoordinateDelegate {
	// Allows the coordinates to be fixed
	func allowFix(_ allowed: Bool) {
		self.fixCoordinates.isHidden = !allowed
		self.centralBottomView.isHidden = !allowed
	}
}

extension MainViewController: HoldingView {
	// Updates the content area of the planeHolder
	func updateHolder(with size: CGSize) {
	}
}

extension MainViewController: UpdateController {
	func updateVector(at idx: Int, with update: Update) {
		self.source.updateVector(at: idx, with: update)
		self.makeUndoAvailable(available: true)
		self.currentCamera = self.currentCamera.pan(xShift: 0, yShift: 0)
	}
	
	func updateCell(at idx: Int, cell: VectorCell) {
		self.source.fillInCellDetails(at: idx, cell: cell)
	}
	
	func removeVector(at idx: Int) {
		self.source.removeVector(at: idx)
		self.makeUndoAvailable(available: true)
		self.currentCamera = self.currentCamera.pan(xShift: 0, yShift: 0)
	}
	
	
}

extension MainViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	// Returns the number of rows/vectors
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.source.totalVectors
	}
	
	// Gets the scell from the data source
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "VectorCell", for: indexPath) as? VectorCell{
			cell.xField.restorationIdentifier = "\(indexPath.row)"
			cell.yField.restorationIdentifier = "\(indexPath.row)"
			cell.angleField.restorationIdentifier = "\(indexPath.row)"
			cell.lengthField.restorationIdentifier = "\(indexPath.row)"
			cell.negateButton.restorationIdentifier = "\(indexPath.row)"
			cell.negateButton.addTarget(self, action: #selector(self.negateVector(_:)), for: .touchUpInside)
			cell.xField.delegate = self
			cell.yField.delegate = self
			cell.angleField.delegate = self
			cell.lengthField.delegate = self
			return self.source.fillInCellDetails(at: indexPath.row, cell: cell)
		}
		return UITableViewCell()
	}
}

extension MainViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return textField.endEditing(true)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if let id = textField.restorationIdentifier, let num = Int(id), let type = textField.accessibilityIdentifier, let value = CGFloat.convert(str: textField.text!) {
			if type == "x" {
				self.source.updateVector(at: num, with: .x(val: Decimal(value)))
			} else if type == "angle" {
				self.source.updateVector(at: num, with: .angle(val: Decimal(value)))
			} else if type == "length" {
				self.source.updateVector(at: num, with: .length(val: Decimal(value)))
			} else if type == "y" {
				self.source.updateVector(at: num, with: .y(val: Decimal(value)))
			} else {
				return
			}
			self.currentCamera = self.currentCamera.pan(xShift: 0, yShift: 0)
			self.tableView.updateCell(at: num)
		}
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
		return lhs.width < rhs.width && lhs.height < rhs.height
	}
}

extension CGPoint {
	func midPoint(with other: CGPoint) -> CGPoint {
		return CGPoint(x: (self.x + other.x) / 2, y: (self.y + other.y) / 2)
	}
}

