//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Localization = Localizable.Presentation.Tutorial.Page1

class TutorialPresentationPage1: TutorialPresentationPage {

  init() {
    let content = UIView()
    content.backgroundColor = UIColor.red
    content.alpha           = 0.5
    super.init(content: content, title: Localization.title, caption: Localization.caption)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
