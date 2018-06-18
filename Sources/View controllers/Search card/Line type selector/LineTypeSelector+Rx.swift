//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

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
