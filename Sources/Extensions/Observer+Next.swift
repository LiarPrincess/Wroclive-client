//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import RxSwift

extension ObserverType where E == Void {
  func onNext() {
    self.onNext(())
  }
}
