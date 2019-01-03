// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import RxSwift

public protocol DebugManagerType {

  #if DEBUG

  /// Clear NSURLSession cache
  func clearNetworkCache()

  /// Print Rx resource count every 1s
  func printRxResources()

  #endif
}

// sourcery: manager
public final class DebugManager: DebugManagerType {

  #if DEBUG

  let disposeBag = DisposeBag()

  public init() { }

  public func clearNetworkCache() {
    URLCache.shared.removeAllCachedResponses()
  }

  public func printRxResources() {
    _ = Observable<Int>
      .interval(1, scheduler: AppEnvironment.schedulers.main)
      .subscribe { _ in print("Resource count: \(RxSwift.Resources.total)") }
      .disposed(by: self.disposeBag)
  }

  #endif
}
