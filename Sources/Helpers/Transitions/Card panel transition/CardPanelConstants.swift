//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum CardPanelConstants {

  enum AnimationDurations {
    static let present: TimeInterval = 0.3
    static let dismiss: TimeInterval = 0.3
  }

  enum FinishConditions {
    static let minVelocityUp:   CGFloat = 150.0
    static let minVelocityDown: CGFloat = 550.0
    static let minProgress:     CGFloat =   0.5
  }

  enum Presenter {
    static let backgroundColor: UIColor = .black
    static let backgroundAlpha: CGFloat = 0.4

    static let topCornerRadius: CGFloat = 12.0
  }
}
