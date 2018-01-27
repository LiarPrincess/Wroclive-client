//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// source: https://github.com/HarshilShah/DeckTransition <- THIS
//         http://martinnormark.com/presenting-ios-view-controller-as-bottom-half-modal/
//         https://stackoverflow.com/a/36775217

private typealias AnimationDurations = CardPanelConstants.AnimationDurations

class CardPanelTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

  // MARK: - Properties

  private weak var presentable: CardPanelPresentable?
  private let interactiveDismissTransition: CardPanelInteractiveDismissTransition

  // MARK: - Init

  init(for presentable: CardPanelPresentable) {
    self.presentable = presentable
    self.interactiveDismissTransition = CardPanelInteractiveDismissTransition(for: presentable)
    super.init()
  }

  // MARK: - Transition

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CardPanelPresentationTransition(AnimationDurations.present)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CardPanelDismissTransition(AnimationDurations.dismiss)
  }

  // MARK: - Interactive transition

  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactiveDismissTransition.hasStarted ? interactiveDismissTransition : nil
  }

  // MARK: - Presentation

  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return CardPanelPresenter(forPresented: presented, presenting: presenting, as: self.presentable)
  }
}
