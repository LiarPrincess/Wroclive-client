// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private typealias TextStyles = LineSelectorHeaderViewConstants.TextStyles

class LineSelectorHeaderViewModel {
  let text: NSAttributedString

  init(_ section: LineSelectorSection) {
    let translation = section.model.lineSubtypeTranslation
    self.text = NSAttributedString(string: translation, attributes: TextStyles.header)
  }
}
