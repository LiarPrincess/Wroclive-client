// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import Foundation

private typealias Constants = MapViewControllerConstants.Pin

class VehicleAnnotationView: MKAnnotationView {

  private let pinView  = VehiclePinView()
  private let pinLabel = UILabel()

  // MARK: - Init

  init(_ vehicleAnnotation: VehicleAnnotation, reuseIdentifier: String?) {
    super.init(annotation: vehicleAnnotation, reuseIdentifier: reuseIdentifier)
    self.frame          = CGRect(origin: .zero, size: Constants.imageSize)
    self.isDraggable    = false
    self.canShowCallout = false

    self.pinView.frame = self.frame
    self.addSubview(self.pinView)
    self.addSubview(self.pinLabel)

    self.updateImage()
    self.updateLabel()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Set vehicle location

  func setVehicleAnnotation(_ annotation: VehicleAnnotation) {
    self.annotation = annotation
    self.updateImage()
    self.updateLabel()
  }

  // MARK: Update image

  func updateImage() {
    guard let annotation = self.annotation as? VehicleAnnotation else { return }

    let color = self.imageColor(for: annotation)
    let hasColorChanged = self.pinView.tintColor != color
    let hasAngleChanged = abs(self.pinView.angle - annotation.angle) > Constants.minAngleChangeToRedraw

    if hasColorChanged || hasAngleChanged {
      self.pinView.tintColor = color
      self.pinView.angle     = annotation.angle
      self.pinView.setNeedsDisplay()
    }
  }

  private func imageColor(for annotation: VehicleAnnotation) -> UIColor {
    switch annotation.line.type {
    case .tram: return AppEnvironment.current.theme.colors.tram
    case .bus:  return AppEnvironment.current.theme.colors.bus
    }
  }

  // MARK: Update label

  func updateLabel() {
    guard let annotation = self.annotation as? VehicleAnnotation else { return }

    let textAttributes = TextAttributes(style: .body, color: .background, alignment: .center)
    self.pinLabel.attributedText = NSAttributedString(string: annotation.line.name, attributes: textAttributes)

    let imageSize  = Constants.imageSize
    let labelSize  = self.pinLabel.intrinsicContentSize
    let labelOrgin = CGPoint(x: (imageSize.width - labelSize.width) / 2.0, y: (imageSize.height - labelSize.height) / 2.0)
    self.pinLabel.frame = CGRect(origin: labelOrgin, size: labelSize)
  }

  private func textColor(for annotation: VehicleAnnotation) -> TextColor {
    switch annotation.line.type {
    case .tram: return .tram
    case .bus:  return .bus
    }
  }
}

// MARK: - VehiclePinView

private class VehiclePinView: UIView {

  var angle: CGFloat = 0.0 {
    didSet { self.transform = CGAffineTransform(rotationAngle: self.angle.rad) }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.allowsEdgeAntialiasing = true
    self.backgroundColor              = UIColor.clear
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    let color    = self.tintColor ?? UIColor.black
    let resizing = StyleKit.ResizingBehavior.aspectFit
    StyleKit.drawVehiclePin(frame: self.bounds, color: color, resizing: resizing)
  }
}