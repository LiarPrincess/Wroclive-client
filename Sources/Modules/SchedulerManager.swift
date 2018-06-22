// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift

class SchedulerManager: SchedulerManagerType {
  var main:      SchedulerType { return MainScheduler.instance }
  var mainAsync: SchedulerType { return MainScheduler.asyncInstance }
}
