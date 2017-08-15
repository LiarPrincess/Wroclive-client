//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import Foundation

fileprivate typealias Layout = MapViewControllerConstants.Layout

class VehicleLocationAnnotationView: MKAnnotationView {

  private let lineLabel = UILabel()

  // MARK: - Init

  init(vehicleLocation: VehicleLocationAnnotation, reuseIdentifier: String?) {
    super.init(annotation: vehicleLocation, reuseIdentifier: reuseIdentifier)
    self.isDraggable    = false
    self.canShowCallout = false
    self.addSubview(lineLabel)
    self.redraw()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Set vehicle location

  func setVehicleLocationAnnotation(_ vehicleLcation: VehicleLocationAnnotation) {
    self.annotation = vehicleLcation
    self.redraw()
  }

  func redraw() {
    if let annotation = self.annotation as? VehicleLocationAnnotation {
      self.updateImage(for: annotation)
      self.updateLineLabel(for: annotation)
    }
    else {
      self.image                    = nil
      self.lineLabel.attributedText = nil
    }
  }

  private func colorForLineType(_ lineType: LineType) -> UIColor {
    return lineType == .bus
      ? Theme.current.colorScheme.bus
      : Theme.current.colorScheme.tram
  }

  private func updateImage(for annotation: VehicleLocationAnnotation) {
    let color  = self.colorForLineType(annotation.line.type)
    self.image = StyleKit.drawPinImage(size: Layout.pinImageSize, background: color, renderingMode: .alwaysOriginal)
  }

  private func updateLineLabel(for annotation: VehicleLocationAnnotation) {
    let color  = self.colorForLineType(annotation.line.type)

    let textAttributes: [String:Any] = [
      NSFontAttributeName:            Theme.current.font.body,
      NSForegroundColorAttributeName: color
    ]

    self.lineLabel.attributedText = NSAttributedString(string: annotation.line.name, attributes: textAttributes)
    self.lineLabel.textAlignment  = .center

    let pinSize    = Layout.pinImageSize
    let labelSize  = self.lineLabel.intrinsicContentSize
    let labelOrgin = CGPoint(x: (pinSize.width - labelSize.width) / 2.0, y: pinSize.height)
    self.lineLabel.frame = CGRect(origin: labelOrgin, size: labelSize)
  }

}
