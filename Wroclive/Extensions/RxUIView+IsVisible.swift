// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
  /// Bindable sink for opposite of `hidden` property.
  public var isVisible: Binder<Bool> {
    return Binder(self.base) { view, value in
      view.isHidden = !value
    }
  }
}
