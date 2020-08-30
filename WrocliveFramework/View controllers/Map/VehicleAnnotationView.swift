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

  // swiftlint:disable:next unavailable_function
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

    let color = annotation.line.annotationColor
    let hasColorChanged = self.roundedRectangle.tintColor != color

    let angleDiff = abs(self.roundedRectangle.angle - annotation.angle)
    let hasAngleChanged = angleDiff > Constants.minAngleChangeToRedraw

    if hasColorChanged || hasAngleChanged {
      self.roundedRectangle.tintColor = color
      self.roundedRectangle.angle = annotation.angle
      self.roundedRectangle.setNeedsDisplay()
    }
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

  // swiftlint:disable:next unavailable_function
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    let color = self.tintColor ?? UIColor.black
    let resizing = StyleKit.ResizingBehavior.aspectFit
    StyleKit.drawVehicleAnnotation(frame: self.bounds,
                                   color: color,
                                   resizing: resizing)
  }
}
