// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: LineTypeSelector {
  var selectedValueChanged: ControlEvent<LineType> {
    return ControlEvent(events:
      self.controlEvent([.allEditingEvents, .valueChanged])
        .map { self.base.selectedValue }
    )
  }
}
