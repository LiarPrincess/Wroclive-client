//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct CardPanelConstants {

  struct AnimationDuration {
    static let present: TimeInterval = 0.30
    static let dismiss: TimeInterval = 0.25
  }

  struct FinishConditions {
    static let minVelocityUp:   CGFloat = 150.0
    static let minVelocityDown: CGFloat = 550.0
    static let minProgress:     CGFloat =   0.5
  }

  struct Presenter {
    static let backgroundColor: UIColor = .black
    static let backgroundAlpha: CGFloat = 0.4
  }

}
