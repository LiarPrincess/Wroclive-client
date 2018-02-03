//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum CardPanelConstants {

  enum Layout {
    static let topCornerRadius: CGFloat = 12.0

    enum DimmingView {
      static let color: UIColor = .black
      static let alpha: CGFloat = 0.4
    }
  }

  enum AnimationDurations {
    static let present: TimeInterval = 0.3
    static let dismiss: TimeInterval = 0.3
  }

  enum DismissGesture {
    static let elasticThreshold: CGFloat = 120
    static let dismissThreshold: CGFloat = 240

    static let translationFactor: CGFloat = 0.5
  }
}
