//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct MainViewControllerConstants {

  //MARK: - Storyboards

  struct Storyboards {
    static let Main = "Main"
  }

  struct Segues {
    static let showBookmarksViewController = "ShowBookmarksViewController"
  }

  //MARK: - Transitions

  struct ModalCardTransition {
    struct AnimationDuration {
      static let present: TimeInterval = 0.35
      static let dismiss: TimeInterval = 0.60

      //division between 'sliding down modal' and 'showing up toolbar' phases
      static let dismissTimingDistribution: TimeInterval = 0.55
    }

    struct DimmingView {
      static let color: UIColor = .darkGray
      static let alpha: CGFloat = 0.5
    }
  }

  //MARK: - ViewControllers

  struct BookmarksViewController {
    static let identifier = "BookmarksViewController"
    static let relativeHeight: CGFloat = 0.75
  }

  struct MapViewController {
    //todo
  }

  struct MainViewController {
    struct UserTrackingImages {
      static let none              = "vecUserTracking_None"
      static let follow            = "vecUserTracking_Follow"
      static let followWithHeading = "vecUserTracking_Follow"
    }
  }
}
