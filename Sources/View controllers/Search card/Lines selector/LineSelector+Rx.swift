//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: LineSelector {
  var pageDidTransition: ControlEvent<LineType> { return ControlEvent(events: self.base.pageDidTransition) }
  var lineSelected:      ControlEvent<Line>     { return ControlEvent(events: self.base.lineSelected)      }
  var lineDeselected:    ControlEvent<Line>     { return ControlEvent(events: self.base.lineDeselected)    }
}
