//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
  /// Bindable sink for opposite of `hidden` property.
  public var isVisible: Binder<Bool> {
    return Binder(self.base) { view, isVisible in
      view.isHidden = !isVisible
    }
  }
}
