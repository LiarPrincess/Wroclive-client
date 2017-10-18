//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

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
    self.redraw()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Set vehicle location

  func setVehicleAnnotation(_ annotation: VehicleAnnotation) {
    self.annotation = annotation
    self.redraw()
  }

  func redraw() {
    if let annotation = self.annotation as? VehicleAnnotation {
      self.updateImage(for: annotation)
      self.updateLabel(for: annotation)
    }
  }

  private func updateImage(for annotation: VehicleAnnotation) {
    let colorScheme = Managers.theme.colors
    let color       = annotation.line.type == .bus ? colorScheme.busColor : colorScheme.tramColor

    let hasColorChanged = self.pinView.tintColor != color.value
    let hasAngleChanged = abs(self.pinView.angle - annotation.angle) > Constants.minAngleChangeToRedraw

    if hasColorChanged || hasAngleChanged {
      self.pinView.tintColor = color.value
      self.pinView.angle     = annotation.angle
      self.pinView.setNeedsDisplay()
    }
  }

  private func updateLabel(for annotation: VehicleAnnotation) {
    let textColor: TextColor = annotation.line.type == .bus ? .bus : .tram
    let textAttributes = Managers.theme.textAttributes(for: .body, alignment: .center, color: textColor)
    self.pinLabel.attributedText = NSAttributedString(string: annotation.line.name, attributes: textAttributes)

    let imageSize  = Constants.imageSize
    let labelSize  = self.pinLabel.intrinsicContentSize
    let labelOrgin = CGPoint(x: (imageSize.width - labelSize.width) / 2.0, y: imageSize.height)
    self.pinLabel.frame = CGRect(origin: labelOrgin, size: labelSize)
  }
}
