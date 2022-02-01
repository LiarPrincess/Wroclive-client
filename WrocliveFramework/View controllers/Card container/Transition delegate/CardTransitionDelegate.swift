// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// source: https://github.com/HarshilShah/DeckTransition <- THIS
//         http://martinnormark.com/presenting-ios-view-controller-as-bottom-half-modal/
//         https://stackoverflow.com/a/36775217

private typealias AnimationDurations = CardContainer.Constants.AnimationDurations

public final class CardTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

  private let height: CGFloat

  public init(height: CGFloat) {
    self.height = height
    super.init()
  }

  public func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return CardPresentationTransition(AnimationDurations.present)
  }

  public func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return CardDismissTransition(AnimationDurations.dismiss)
  }

  public func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    guard let card = presented as? CardContainer else {
      fatalError("'CardTransitionDelegate' should only be used with 'CardContainer'")
    }

    return CardPresenter(forPresented: card,
                         presenting: presenting,
                         height: self.height)
  }
}
