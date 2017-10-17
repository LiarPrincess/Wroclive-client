//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

struct PresentationControllerPageParameters {
  let view:    UIView
  let title:   String
  let caption: String

  let leftOffset:  CGFloat
  let rightOffset: CGFloat

  let titleTopOffset:   CGFloat
  let captionTopOffset: CGFloat

  let captionLineSpacing: CGFloat = 5.0

  init(view:       UIView,
       title:      String,  titleTopOffset:   CGFloat,
       caption:    String,  captionTopOffset: CGFloat,
       leftOffset: CGFloat, rightOffset:      CGFloat) {
    self.view    = view
    self.title   = title
    self.caption = caption

    self.leftOffset  = leftOffset
    self.rightOffset = rightOffset

    self.titleTopOffset   = titleTopOffset
    self.captionTopOffset = captionTopOffset
  }
}
