// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public struct SystemFont: FontPreset {
  public private(set) var largeTitle = UIFont()
  public private(set) var headline   = UIFont()
  public private(set) var body       = UIFont()
  public private(set) var bodyBold   = UIFont()
  public private(set) var footnote   = UIFont()

  public init() {
    self.recalculateSizes()
  }

  public mutating func recalculateSizes() {
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
