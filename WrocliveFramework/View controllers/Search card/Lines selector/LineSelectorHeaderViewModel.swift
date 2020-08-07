// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private typealias TextStyles = LineSelectorHeaderViewConstants.TextStyles

public final class LineSelectorHeaderViewModel {

  public let text: NSAttributedString

  public init(section: LineSelectorSection) {
    let translation = section.lineSubtypeTranslation
    self.text = NSAttributedString(string: translation,
                                   attributes: TextStyles.header)
  }
}
