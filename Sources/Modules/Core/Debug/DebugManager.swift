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

  func debugRxResources() {
    _ = Observable<Int>
      .interval(1, scheduler: MainScheduler.instance)
      .subscribe { _ in print("Resource count: \(RxSwift.Resources.total)") }
      .disposed(by: self.disposeBag)
  }

  #endif
}
