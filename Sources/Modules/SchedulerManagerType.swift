//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol SchedulerManagerType {
  var main:      SchedulerType { get }
  var mainAsync: SchedulerType { get }
}
