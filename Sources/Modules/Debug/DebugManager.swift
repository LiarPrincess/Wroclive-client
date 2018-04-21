//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

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
      .interval(1, scheduler: Managers.schedulers.main)
      .subscribe { _ in print("Resource count: \(RxSwift.Resources.total)") }
      .disposed(by: self.disposeBag)
  }

  #endif
}
