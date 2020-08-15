// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol CustomCardPanelPresentable: AnyObject {

  /// Scroll view that can be used to dismiss card.
  var scrollView: UIScrollView? { get }

  func interactiveDismissalWillBegin()
  func interactiveDismissalProgress(percent: CGFloat)
  func interactiveDismissalDidEnd(completed: Bool)
}

extension CustomCardPanelPresentable {
  public var scrollView: UIScrollView? { return nil }

  public func interactiveDismissalWillBegin() {}
  public func interactiveDismissalProgress(percent: CGFloat) {}
  public func interactiveDismissalDidEnd(completed: Bool) {}
}

extension UINavigationController: CustomCardPanelPresentable {

  private var card: CustomCardPanelPresentable? {
    return self.topViewController as? CustomCardPanelPresentable
  }

  public var scrollView: UIScrollView? {
    return self.card?.scrollView
  }

  public func interactiveDismissalWillBegin() {
    self.card?.interactiveDismissalWillBegin()
  }

  public func interactiveDismissalProgress(percent: CGFloat) {
    self.card?.interactiveDismissalProgress(percent: percent)
  }

  public func interactiveDismissalDidEnd(completed: Bool) {
    self.card?.interactiveDismissalDidEnd(completed: completed)
  }
}
