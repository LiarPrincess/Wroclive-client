//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: LineTypeSelector {

  /**
   ControlProperty:
   - `shareReplay(1)` behavior
   - programatic value changes won't be reported.
   */
  var selectedValue: ControlProperty<LineType> {
    return controlProperty(
      editingEvents: [.allEditingEvents, .valueChanged],
      getter: { $0.selectedValue },
      setter: { $0.setSelectedValueNotReactive($1) }
    )
  }
}
