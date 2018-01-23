//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift

class DebugManager: DebugManagerType {

  #if !DEBUG

  func initialize() { }

  #else

  let disposeBag = DisposeBag()

  func initialize() {
//    self.observeRxResources()
//    self.removeNetworkCache()
  }

  private func observeRxResources() {
    _ = Observable<Int>
      .interval(1, scheduler: MainScheduler.instance)
      .subscribe { _ in print("Resource count \(RxSwift.Resources.total)") }
      .disposed(by: self.disposeBag)
  }

  private func removeNetworkCache() {
    URLCache.shared.removeAllCachedResponses()
  }

  #endif
}
