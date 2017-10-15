//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class PresentationControllerPageFactory {
  static func create(_ parameters: [PresentationControllerPageParameters]) -> [PresentationControllerPage] {
    let pages = parameters.map { PresentationControllerPage($0) }

    let minTextHeight = pages.map { $0.calculateMinTextHeight() }.max() ?? 0.0
    for page in pages {
      page.guaranteeMinTextHeight(minTextHeight)
    }

    return pages
  }
}
