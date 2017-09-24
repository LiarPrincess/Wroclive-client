//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// source: http://martinnormark.com/presenting-ios-view-controller-as-bottom-half-modal/
//         https://github.com/HarshilShah/DeckTransition

private typealias Constants = CardPanelConstants

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
    let duration = self.presentable?.presentationTransitionDuration ?? Constants.AnimationDuration.present
    return CardPanelPresentationTransition(duration)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let duration = self.presentable?.dismissTransitionDuration ?? Constants.AnimationDuration.dismiss
    return CardPanelDismissTransition(duration)
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
