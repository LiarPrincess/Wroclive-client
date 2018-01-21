//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift

class DebugManager: DebugManagerType {
  func initialize() {
    #if DEBUG
//      self.observeRxResources()
//      self.removeNetworkCache()
    #endif
  }

  #if DEBUG

  private func observeRxResources() {
    _ = Observable<Int>
      .interval(1, scheduler: MainScheduler.instance)
      .subscribe { _ in print("Resource count \(RxSwift.Resources.total)") }
  }

  private func removeNetworkCache() {
    URLCache.shared.removeAllCachedResponses()
  }

  #endif
}
