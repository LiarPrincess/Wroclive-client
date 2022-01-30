// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import Foundation

private typealias Constants = MapViewController.Constants.Pin

public final class VehicleAnnotationView: MKAnnotationView {

  private let label = UILabel()
  private let roundedRectangle = RoundedRectangleWithArrow()

  // MARK: - Init

  public init(annotation: VehicleAnnotation, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    self.frame = CGRect(origin: .zero, size: Constants.imageSize)
    self.isDraggable = false
    self.canShowCallout = false

    self.roundedRectangle.frame = self.frame
    self.addSubview(self.roundedRectangle)
    self.addSubview(self.label)

    self.updateImage()
    self.updateLabel()
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Set vehicle location

  public func setVehicleAnnotation(_ annotation: VehicleAnnotation) {
    self.annotation = annotation
    self.updateImage()
    self.updateLabel()
  }

  // MARK: Update image

  public func updateImage() {
    guard let annotation = self.annotation as? VehicleAnnotation else {
      return
    }

    // We could decrease number of calls to 'setNeedsDisplay' by comparing
    // new color and angle to previous values. But since we refresh vehicle
    // locations every X seconds (not frames) that would not save a lot energy
    //
    // If you change this code, then remember to check what happens when we show
    // alert (all annotation go grey -> do they recover without 'setNeedsDisplay'?).
    self.roundedRectangle.tintColor = annotation.line.annotationColor
    self.roundedRectangle.angle = annotation.angle
    self.roundedRectangle.setNeedsDisplay()
  }

  // MARK: Update label

  private static let textAttributes = TextAttributes(style: .body,
                                                     color: .white,
                                                     alignment: .center)

  public func updateLabel() {
    guard let annotation = self.annotation as? VehicleAnnotation else {
      return
    }

    self.label.attributedText = NSAttributedString(
      string: annotation.line.name,
      attributes: Self.textAttributes
    )

    let imageSize = Constants.imageSize
    let size = self.label.intrinsicContentSize
    let origin = CGPoint(x: (imageSize.width - size.width) / 2.0,
                         y: (imageSize.height - size.height) / 2.0)
    self.label.frame = CGRect(origin: origin, size: size)
  }
}

// MARK: - RoundedRectangleWithArrow

private class RoundedRectangleWithArrow: UIView {

  var angle: CGFloat = 0.0 {
    didSet {
      self.transform = CGAffineTransform(rotationAngle: self.angle.rad)
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.allowsEdgeAntialiasing = true
    self.backgroundColor = UIColor.clear
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    StyleKit.drawVehicleAnnotation(frame: self.bounds,
                                   color: self.tintColor ?? .black,
                                   resizing: .aspectFit)
  }
}
