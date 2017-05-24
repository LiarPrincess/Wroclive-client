//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

struct CardPanelConstants {
  struct AnimationDuration {
    static let present: TimeInterval = 0.35
    static let dismiss: TimeInterval = 0.35
  }

  struct Interactive {
    static let minVelocityToFinish: CGFloat = 100.0
    static let minProgressToFinish: CGFloat = 0.2
  }

  struct Presenter {
    static let backgroundColor: UIColor = .darkGray
    static let backgroundAlpha: CGFloat = 0.5
  }
}

// source: http://martinnormark.com/presenting-ios-view-controller-as-bottom-half-modal/

class CardPanelTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

  //MARK: - Properties

  private let relativeHeight: CGFloat
  private let interactiveTransition: CardPanelInteractiveTransition

  //MARK: - Init

  init(for presentable: CardPanelPresentable, withRelativeHeight relativeHeight: CGFloat) {
    self.relativeHeight = relativeHeight
    self.interactiveTransition = CardPanelInteractiveTransition(for: presentable)
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
    return interactiveTransition.hasStarted ? interactiveTransition : nil
  }

  //MARK: - Presentation

  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return CardPanelPresenter(forPresented: presented, presenting: presenting, relativeHeight: self.relativeHeight)
  }

}
