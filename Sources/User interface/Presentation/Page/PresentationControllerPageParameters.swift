//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct PresentationControllerPageParameters {
  let image:   UIImage
  let title:   String
  let caption: String

  let leftOffset:  CGFloat
  let rightOffset: CGFloat

  let titleTopOffset:     CGFloat
  let captionTopOffset:   CGFloat
  let captionLineSpecing: CGFloat

  init(_ image: UIImage, _ title: String, _ caption: String,
       _ leftOffset: CGFloat, _ rightOffset: CGFloat,
       _ titleTopOffset: CGFloat,
       _ captionTopOffset: CGFloat, _ captionLineSpecing: CGFloat) {
    self.image   = image
    self.title   = title
    self.caption = caption

    self.leftOffset  = leftOffset
    self.rightOffset = rightOffset

    self.titleTopOffset     = titleTopOffset
    self.captionTopOffset   = captionTopOffset
    self.captionLineSpecing = captionLineSpecing
  }
}
