//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

class SchedulerManager: SchedulerManagerType {
  var main:      SchedulerType { return MainScheduler.instance }
  var mainAsync: SchedulerType { return MainScheduler.asyncInstance }
}
