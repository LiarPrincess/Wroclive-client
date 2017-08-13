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
      StyleKit.drawSearch(frame: frame, resizing: .aspectFit)
    }
  }

  class func drawStarImage(size: CGSize, renderingMode: UIImageRenderingMode) -> UIImage {
    return StyleKit.drawImage(size: size, renderingMode: renderingMode) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawStar(frame: frame, resizing: .aspectFit)
    }
  }

  class func drawCogwheelImage(size: CGSize, renderingMode: UIImageRenderingMode) -> UIImage {
    return StyleKit.drawImage(size: size, renderingMode: renderingMode) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawCogwheel(frame: frame, resizing: .aspectFit)
    }
  }

  class func drawPinImage(size: CGSize, background: UIColor, renderingMode: UIImageRenderingMode) -> UIImage {
    return StyleKit.drawImage(size: size, renderingMode: renderingMode) {
      let frame = CGRect(origin: CGPoint(), size: size)
      StyleKit.drawPin(frame: frame, resizing: .aspectFit, background: background)
    }
  }

  // MARK: - Private - Draw image

  private class func drawImage(size: CGSize, renderingMode: UIImageRenderingMode, draw: () -> Void) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)

    draw()

    let image = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(renderingMode)
    UIGraphicsEndImageContext()

    return image
  }
}
