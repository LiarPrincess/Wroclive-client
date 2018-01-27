//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants = CardPanelConstants

protocol CardPanelPresentable: class {
  var height: CGFloat { get }

  var header:     UIView        { get }
  var scrollView: UIScrollView? { get }

  var showChevronView: Bool { get }

  func dismiss(animated flag: Bool, completion: (() -> Swift.Void)?)
}

extension CardPanelPresentable {
  var scrollView: UIScrollView? { return nil }
  var showChevronView: Bool { return true }
}
