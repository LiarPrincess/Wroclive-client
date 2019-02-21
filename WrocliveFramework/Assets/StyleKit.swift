// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_unwrapping
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable type_body_length
// swiftlint:disable file_length
// swiftlint:disable identifier_name

public enum StyleKit {

  public static func drawVehiclePin(frame targetFrame: CGRect,
                                    color: UIColor,
                                    resizing: ResizingBehavior = .aspectFit) {
    // dimensions (x4):
    // arrow height: 24 |  6
    // arrow width:  64 | 16

    // arrow gap:      4 |  1
    // rect width:   128 | 32
    // total: 2 * (24 + 4) + 128 = 184 | 46

    // border width:    8 |  2
    // corners radius: 40 | 10

    // Constants
    let contextSize: CGFloat = 52.0

    let arrowWidth:  CGFloat = 16.0
    let arrowHeight: CGFloat =  6.0
    let arrowGap:    CGFloat =  2.0

    let rectBorderWidth:  CGFloat =  2.0
    let rectCornerRadius: CGFloat = 10.0
    let rectSize:         CGFloat = contextSize - 2 * (arrowHeight + arrowGap)

    let rectFrame = CGRect(x: arrowHeight + arrowGap, y: arrowHeight + arrowGap, width: rectSize, height: rectSize)

    // Drawing
    let context = UIGraphicsGetCurrentContext()!

    context.saveGState()
    let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0.0, y: 0.0, width: contextSize, height: contextSize), target: targetFrame)
    context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
    context.scaleBy(x: resizedFrame.width / contextSize, y: resizedFrame.height / contextSize)

    // Rounded rect
    let rectPath  = UIBezierPath(roundedRect: rectFrame, cornerRadius: rectCornerRadius)
    color.withAlphaComponent(0.75).setFill()
    rectPath.fill()
    color.setStroke()
    rectPath.lineWidth = rectBorderWidth
    rectPath.stroke()

    // Arrow
    let arrowPath = UIBezierPath()
    arrowPath.move(to: CGPoint(x: (contextSize - arrowWidth) / 2, y: arrowHeight))
    arrowPath.addLine(to: CGPoint(x: contextSize / 2, y: 0))
    arrowPath.addLine(to: CGPoint(x: (contextSize + arrowWidth) / 2, y: arrowHeight))
    arrowPath.close()
    color.setFill()
    arrowPath.fill()

    context.restoreGState()
  }

  public enum ResizingBehavior: Int {
    case aspectFit /// The content is proportionally resized to fit into the target rectangle.
    case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
    case stretch /// The content is stretched to match the entire target rectangle.
    case center /// The content is centered in the target rectangle, but it is NOT resized.

    public func apply(rect: CGRect, target: CGRect) -> CGRect {
      if rect == target || target == CGRect.zero {
        return rect
      }

      var scales = CGSize.zero
      scales.width = abs(target.width / rect.width)
      scales.height = abs(target.height / rect.height)

      switch self {
      case .aspectFit:
        scales.width = min(scales.width, scales.height)
        scales.height = scales.width
      case .aspectFill:
        scales.width = max(scales.width, scales.height)
        scales.height = scales.width
      case .stretch:
        break
      case .center:
        scales.width = 1
        scales.height = 1
      }

      var result = rect.standardized
      result.size.width *= scales.width
      result.size.height *= scales.height
      result.origin.x = target.minX + (target.width - result.width) / 2
      result.origin.y = target.minY + (target.height - result.height) / 2
      return result
    }
  }
}
