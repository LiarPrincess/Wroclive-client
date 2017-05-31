//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct CardPanelConstants {

  struct AnimationDuration {
    static let present: TimeInterval = 0.35
    static let dismiss: TimeInterval = 0.30
  }

  struct Interactive {
    static let minVelocityToFinish: CGFloat = 300.0
    static let minProgressToFinish: CGFloat = 0.2
  }

  struct Presenter {
    static let backgroundColor: UIColor = .darkGray
    static let backgroundAlpha: CGFloat = 0.5
  }

}
