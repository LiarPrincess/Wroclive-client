// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift

public protocol SchedulersManagerType {
  var main: SchedulerType { get }
}

// sourcery: manager
public final class SchedulersManager: SchedulersManagerType {
  public var main: SchedulerType { return MainScheduler.instance }

  public init() { }
}
