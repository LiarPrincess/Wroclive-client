//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// source: http://martinnormark.com/presenting-ios-view-controller-as-bottom-half-modal/

class CardPanelTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

  //MARK: - Properties

  private let relativeHeight:               CGFloat
  private let interactiveDismissTransition: CardPanelInteractiveDismissTransition

  //MARK: - Init

  init(for presentable: CardPanelPresentable, withRelativeHeight relativeHeight: CGFloat) {
    self.relativeHeight        = relativeHeight
    self.interactiveDismissTransition = CardPanelInteractiveDismissTransition(for: presentable)
    super.init()
  }

  //MARK: - Transition

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CardPanelPresentationTransition()
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CardPanelDismissTransition()
  }

  //MARK: - Interactive transition

  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactiveDismissTransition.hasStarted ? interactiveDismissTransition : nil
  }

  //MARK: - Presentation

  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return CardPanelPresenter(forPresented: presented, presenting: presenting, relativeHeight: self.relativeHeight)
  }

}
