//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// source: http://martinnormark.com/presenting-ios-view-controller-as-bottom-half-modal/

private typealias Constants = CardPanelConstants

class CardPanelTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

  // MARK: - Properties

  private let relativeHeight:               CGFloat
  private let interactiveDismissTransition: CardPanelInteractiveDismissTransition

  // MARK: - Init

  init(for presentable: CardPanelPresentable) {
    self.relativeHeight = presentable.relativeHeight
    self.interactiveDismissTransition = CardPanelInteractiveDismissTransition(for: presentable)
    super.init()
  }

  // MARK: - Transition

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let transitionDuration = Double(self.relativeHeight) * Constants.AnimationDuration.present
    return CardPanelPresentationTransition(transitionDuration)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let transitionDuration = Double(self.relativeHeight) * Constants.AnimationDuration.dismiss
    return CardPanelDismissTransition(transitionDuration)
  }

  // MARK: - Interactive transition

  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactiveDismissTransition.hasStarted ? interactiveDismissTransition : nil
  }

  // MARK: - Presentation

  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return CardPanelPresenter(forPresented: presented, presenting: presenting, relativeHeight: self.relativeHeight)
  }
}
