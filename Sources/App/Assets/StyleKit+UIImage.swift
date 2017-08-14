//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

extension StyleKit {

  // MARK: - Draw images

  class func drawSearchImage(size: CGSize, renderingMode: UIImageRenderingMode) -> UIImage {
    return StyleKit.drawImage(size: size, renderingMode: renderingMode) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawSearch(frame: frame, resizing: resizingBehavior)
    }
  }

  class func drawStarImage(size: CGSize, renderingMode: UIImageRenderingMode) -> UIImage {
    return StyleKit.drawImage(size: size, renderingMode: renderingMode) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawStar(frame: frame, resizing: resizingBehavior)
    }
  }

  class func drawCogwheelImage(size: CGSize, renderingMode: UIImageRenderingMode) -> UIImage {
    return StyleKit.drawImage(size: size, renderingMode: renderingMode) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawCogwheel(frame: frame, resizing: resizingBehavior)
    }
  }

  class func drawPinImage(size: CGSize, background: UIColor, renderingMode: UIImageRenderingMode) -> UIImage {
    return StyleKit.drawImage(size: size, renderingMode: renderingMode) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawPin(frame: frame, resizing: resizingBehavior, background: background)
    }
  }

  class func drawCloseImage(size: CGSize, renderingMode: UIImageRenderingMode) -> UIImage {
    return StyleKit.drawImage(size: size, renderingMode: renderingMode) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawClose(frame: frame, resizing: resizingBehavior)
    }
  }

  // MARK: - Private - Drawing

  private class var resizingBehavior: ResizingBehavior { return .aspectFit }

  private class func drawImage(size: CGSize, renderingMode: UIImageRenderingMode, draw: () -> Void) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)

    draw()

    let image = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(renderingMode)
    UIGraphicsEndImageContext()

    return image
  }
}
