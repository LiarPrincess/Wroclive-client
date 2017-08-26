//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// https://stackoverflow.com/a/43192486
extension StyleKit {

  class func createSearchTextAttachment(font: UIFont) -> NSTextAttachment {
    let imageSize = self.calculateAttachmentImageSize(font)
    let imageY    = self.calculateAttachmentImageY(font, imageSize)

    let image = StyleKit.drawSearchTemplateImage(size: CGSize(width: imageSize, height: imageSize))

    let attachment    = NSTextAttachment()
    attachment.image  = image
    attachment.bounds = CGRect(origin: CGPoint(x: 0.0, y: imageY), size: image.size)
    return attachment
  }

  class func createStarTextAttachment(font: UIFont) -> NSTextAttachment {
    let imageSize = self.calculateAttachmentImageSize(font)
    let imageY    = self.calculateAttachmentImageY(font, imageSize)

    let image = StyleKit.drawStarTemplateImage(size: CGSize(width: imageSize, height: imageSize))

    let attachment    = NSTextAttachment()
    attachment.image  = image
    attachment.bounds = CGRect(origin: CGPoint(x: 0.0, y: imageY), size: image.size)
    return attachment
  }

  private class func calculateAttachmentImageSize(_ font: UIFont) -> CGFloat {
    return abs(font.ascender) + abs(font.descender)
  }

  private class func calculateAttachmentImageY(_ font: UIFont, _ imageSize: CGFloat) -> CGFloat {
    return font.ascender - imageSize
  }
}
