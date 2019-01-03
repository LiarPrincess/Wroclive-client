// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: LineSelector {
  public var pageDidTransition: ControlEvent<LineType> { return ControlEvent(events: self.base.pageDidTransition) }
  public var lineSelected:      ControlEvent<Line>     { return ControlEvent(events: self.base.lineSelected)      }
  public var lineDeselected:    ControlEvent<Line>     { return ControlEvent(events: self.base.lineDeselected)    }
}
