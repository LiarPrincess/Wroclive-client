//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

private typealias TextStyles = LineSelectorHeaderViewConstants.TextStyles

class LineSelectorHeaderViewModel {
  let text: NSAttributedString

  init(_ section: LineSelectorSection) {
    let translation = section.model.lineSubtypeTranslation
    self.text = NSAttributedString(string: translation, attributes: TextStyles.header)
  }
}
