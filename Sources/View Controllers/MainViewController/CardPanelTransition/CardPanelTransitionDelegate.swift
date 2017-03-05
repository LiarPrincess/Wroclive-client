//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

struct CardPanelConstants {
  struct AnimationDuration {
    static let present: TimeInterval = 0.35
    static let dismiss: TimeInterval = 0.60

    //division between 'sliding down modal' and 'showing up toolbar' phases
    static let dismissTimingDistribution: TimeInterval = 0.55
  }

  struct Presenter {
    static let backgroundColor: UIColor = .darkGray
    static let backgroundAlpha: CGFloat = 0.5
  }
}

//source: http://martinnormark.com/presenting-ios-view-controller-as-bottom-half-modal/
class CardPanelTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

  //MARK: - Properties

  private let relativeHeight: CGFloat

  //MARK: - Init

  init(withRelativeHeight relativeHeight: CGFloat) {
    self.relativeHeight = relativeHeight
    super.init()
  }

  //MARK: - Transition

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CardPanelPresentationTransition()
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CardPanelDismissTransition()
  }

  //MARK: - Presentation

  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return CardPanelPresenter(forPresented: presented, presenting: presenting, relativeHeight: self.relativeHeight)
  }

}
