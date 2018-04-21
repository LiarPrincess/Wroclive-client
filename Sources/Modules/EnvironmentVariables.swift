//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift

struct EnvironmentVariables {

  let websiteUrl = URL(string: "https://www.overcast.fm")!
  let endpoints  = Endpoints()
  let appStore   = Appstore()
  let timings    = Timings()

  struct Endpoints {
    private let server = "139.59.154.250"
    var lines:     String { return "http://" + server + "/lines" }
    var locations: String { return "http://" + server + "/locations" }
  }

  struct Appstore {
    private let appId = "888422857"
    var writeReviewUrl: URL { return URL(string: "itms-apps://itunes.apple.com/us/app/id\(appId)?action=write-review&mt=8")! }
    var shareUrl:       URL { return URL(string: "https://itunes.apple.com/us/app/overcast/id\(appId)?mt=8")! }
  }

  struct Timings {
    let locationAuthorizationPromptDelay: TimeInterval = 2.0
    let locationUpdateInterval:           TimeInterval = 5.0

    let failedRequestDelay = FailedRequestDelay()

    struct FailedRequestDelay {
      let lines:    TimeInterval = 2.0
      let location: TimeInterval = 3.0
    }
  }
}
