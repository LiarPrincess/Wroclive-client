//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Localization = Localizable.Presentation.InAppPurchase.ColorsPage

class InAppPurchaseColorsPage: InAppPurchasePresentationPage {

  init() {
    let content = ColorSchemeTestView()
    super.init(content: content, title: Localization.title, caption: Localization.caption)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
