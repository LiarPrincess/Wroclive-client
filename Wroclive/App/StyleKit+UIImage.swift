// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

extension StyleKit {

  // MARK: - Draw images

  static func drawSearchTemplateImage(size: CGSize) -> UIImage {
    return StyleKit.drawTemplateImage(size: size) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawSearch(frame: frame, resizing: resizingBehavior)
    }
  }

  static func drawStarTemplateImage(size: CGSize) -> UIImage {
    return StyleKit.drawTemplateImage(size: size) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawStar(frame: frame, resizing: resizingBehavior)
    }
  }

  static func drawStarFilledTemplateImage(size: CGSize) -> UIImage {
    return StyleKit.drawTemplateImage(size: size) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawStarFilled(frame: frame, resizing: resizingBehavior)
    }
  }

  static func drawCogwheelTemplateImage(size: CGSize) -> UIImage {
    return StyleKit.drawTemplateImage(size: size) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawCogwheel(frame: frame, resizing: resizingBehavior)
    }
  }

  static func drawCloseTemplateImage(size: CGSize) -> UIImage {
    return StyleKit.drawTemplateImage(size: size) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawClose(frame: frame, resizing: resizingBehavior)
    }
  }

  // MARK: - Private - Drawing

  private static var resizingBehavior: ResizingBehavior { return .aspectFit }

  private static func drawTemplateImage(size: CGSize, draw: () -> Void) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)

    draw()

    let image = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysTemplate)
    UIGraphicsEndImageContext()

    return image
  }
}
