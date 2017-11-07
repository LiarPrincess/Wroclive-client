//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Localization = Localizable.Presentation.InAppPurchase.Bookmarks

class InAppPurchaseBookmarkPage: InAppPurchasePresentationPage {

  init() {
    let content = UIImageView()
    content.image       = Images.InAppPurchase.bookmarks
    content.contentMode = .scaleToFill
    super.init(content: content, title: Localization.title, caption: Localization.caption)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
