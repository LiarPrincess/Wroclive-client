//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: SettingsMapTypeCell {

  var selectedValueChanged: ControlEvent<MapType> {
    return ControlEvent(events: self.base.selectedValueChanged)
  }
}
