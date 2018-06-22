// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// source: https://github.com/HarshilShah/DeckTransition <- THIS
//         http://martinnormark.com/presenting-ios-view-controller-as-bottom-half-modal/
//         https://stackoverflow.com/a/36775217

private typealias AnimationDurations = CardPanelConstants.AnimationDurations

class CardPanelTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

  // MARK: - Properties

  private weak var cardPanel: CardPanel! // swiftlint:disable:this implicitly_unwrapped_optional

  // MARK: - Init

  init(for cardPanel: CardPanel) {
    self.cardPanel = cardPanel
    super.init()
  }

  // MARK: - Transition

  func animationController(forPresented presented: UIViewController,
                           presenting:             UIViewController,
                           source:                 UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CardPanelPresentationTransition(self.cardPanel.presentationDuration)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CardPanelDismissTransition(self.cardPanel.dismissalDuration)
  }

  // MARK: - Presentation

  func presentationController(forPresented presented: UIViewController,
                              presenting:             UIViewController?,
                              source:                 UIViewController) -> UIPresentationController? {
    return CardPanelPresenter(forPresented: presented, presenting: self.cardPanel)
  }
}
