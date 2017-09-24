//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants = CardPanelConstants

protocol CardPanelPresentable: class {
  var header: UIView  { get }
  var height: CGFloat { get }

  var shouldShowChevronView: Bool { get }

  var presentationTransitionDuration: TimeInterval { get }
  var dismissTransitionDuration:      TimeInterval { get }

  func dismiss(animated flag: Bool, completion: (() -> Swift.Void)?)
}

extension CardPanelPresentable {
  var screenHeight: CGFloat { return UIScreen.main.bounds.height }

  var shouldShowChevronView: Bool { return true }

  var presentationTransitionDuration: TimeInterval { return Constants.AnimationDuration.present }
  var dismissTransitionDuration:      TimeInterval { return Constants.AnimationDuration.dismiss }
}
