//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol SchedulerManagerType {
  var main:      SerialDispatchQueueScheduler { get }
  var mainAsync: SerialDispatchQueueScheduler { get }
}
