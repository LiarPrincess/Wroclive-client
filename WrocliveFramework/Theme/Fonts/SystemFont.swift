// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public struct SystemFont: FontPreset {
  public let largeTitle: UIFont
  public let headline:   UIFont
  public let body:       UIFont
  public let bodyBold:   UIFont
  public let footnote:   UIFont

  public init() {
    // we use 'title1', because '.largeTitle' will not scale
    let largeMetrics    = UIFontMetrics(forTextStyle: .title1)
    let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
    let bodyMetrics     = UIFontMetrics(forTextStyle: .body)
    let footnoteMetrics = UIFontMetrics(forTextStyle: .footnote)

    self.largeTitle = largeMetrics   .scaledFont(for: .systemFont(ofSize: 34.0, weight: .bold))
    self.headline   = headlineMetrics.scaledFont(for: .systemFont(ofSize: 18.0, weight: .bold))
    self.body       = bodyMetrics    .scaledFont(for: .systemFont(ofSize: 17.0))
    self.bodyBold   = bodyMetrics    .scaledFont(for: .systemFont(ofSize: 17.0, weight: .bold))
    self.footnote   = footnoteMetrics.scaledFont(for: .systemFont(ofSize: 14.0))
  }
}
