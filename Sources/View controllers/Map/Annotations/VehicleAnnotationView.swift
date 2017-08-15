//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import Foundation

fileprivate typealias Constants = MapViewControllerConstants
fileprivate typealias Layout    = MapViewControllerConstants.Layout

class VehicleAnnotationView: MKAnnotationView {

  private let pinView  = VehiclePinView()
  private let pinLabel = UILabel()

  // MARK: - Init

  init(_ vehicleAnnotation: VehicleAnnotation, reuseIdentifier: String?) {
    super.init(annotation: vehicleAnnotation, reuseIdentifier: reuseIdentifier)
    self.frame          = CGRect(origin: .zero, size: Layout.pinImageSize)
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

  private func colorForLineType(_ lineType: LineType) -> UIColor {
    let colorScheme = Theme.current.colorScheme
    return lineType == .bus ? colorScheme.bus : colorScheme.tram
  }

  private func updateImage(for annotation: VehicleAnnotation) {
    let color = self.colorForLineType(annotation.line.type)

    let hasColorChanged = self.pinView.tintColor != color
    let hasAngleChanged = abs(self.pinView.angle - annotation.angle) > Constants.minAngleChangeToRedraw

    if hasColorChanged || hasAngleChanged {
      self.pinView.tintColor = color
      self.pinView.angle     = annotation.angle
      self.pinView.setNeedsDisplay()
    }
  }

  private func updateLabel(for annotation: VehicleAnnotation) {
    let color  = self.colorForLineType(annotation.line.type)

    let textAttributes: [String:Any] = [
      NSFontAttributeName:            Theme.current.font.body,
      NSForegroundColorAttributeName: color
    ]

    self.pinLabel.attributedText = NSAttributedString(string: annotation.line.name, attributes: textAttributes)
    self.pinLabel.textAlignment  = .center

    let pinSize    = Layout.pinImageSize
    let labelSize  = self.pinLabel.intrinsicContentSize
    let labelOrgin = CGPoint(x: (pinSize.width - labelSize.width) / 2.0, y: pinSize.height)
    self.pinLabel.frame = CGRect(origin: labelOrgin, size: labelSize)
  }

}
