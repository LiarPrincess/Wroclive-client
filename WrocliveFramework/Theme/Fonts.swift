// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol FontPreset {
  var largeTitle: UIFont { get }
  var headline: UIFont { get }
  var body: UIFont { get }
  var bodyBold: UIFont { get }
  var bodySmall: UIFont { get }
  var bodySmallBold: UIFont { get }
}

public struct SystemFont: FontPreset {

  public let largeTitle: UIFont
  public let headline: UIFont
  public let body: UIFont
  public let bodyBold: UIFont
  public let bodySmall: UIFont
  public let bodySmallBold: UIFont

  public init() {
    // We use 'title1', because '.largeTitle' will not scale
    let largeMetrics = UIFontMetrics(forTextStyle: .title1)
    let headlineMetrics = UIFontMetrics(forTextStyle: .headline)
    let bodyMetrics = UIFontMetrics(forTextStyle: .body)
    let footnoteMetrics = UIFontMetrics(forTextStyle: .footnote)

    self.largeTitle = largeMetrics.scaledFont(for: .systemFont(ofSize: 34.0, weight: .bold))
    self.headline = headlineMetrics.scaledFont(for: .systemFont(ofSize: 18.0, weight: .bold))
    self.body = bodyMetrics.scaledFont(for: .systemFont(ofSize: 17.0))
    self.bodyBold = bodyMetrics.scaledFont(for: .systemFont(ofSize: 17.0, weight: .bold))
    self.bodySmall = footnoteMetrics.scaledFont(for: .systemFont(ofSize: 15.0))
    self.bodySmallBold = bodyMetrics.scaledFont(for: .systemFont(ofSize: 15.0, weight: .bold))
  }
}
