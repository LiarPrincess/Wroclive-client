// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import RxSwift

class DebugManager: DebugManagerType {

  #if DEBUG

  let disposeBag = DisposeBag()

  func clearNetworkCache() {
    URLCache.shared.removeAllCachedResponses()
  }

  func printRxResources() {
    _ = Observable<Int>
      .interval(1, scheduler: AppEnvironment.current.schedulers.main)
      .subscribe { _ in print("Resource count: \(RxSwift.Resources.total)") }
      .disposed(by: self.disposeBag)
  }

  #endif
}
