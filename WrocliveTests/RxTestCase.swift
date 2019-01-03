// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import RxSwift
import RxTest

// swiftlint:disable implicitly_unwrapped_optional

/// Test case that uses Rx
protocol RxTestCase: class {
  var scheduler:  TestScheduler! { get set }
  var disposeBag: DisposeBag!    { get set }
}

extension RxTestCase {

  func setUpRx() {
    self.scheduler  = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }

  func tearDownRx() {
    self.scheduler = nil
    self.disposeBag = nil
  }

  func startScheduler() {
    self.scheduler.start()
  }
}
