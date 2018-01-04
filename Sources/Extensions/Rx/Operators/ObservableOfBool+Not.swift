//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import RxSwift
import RxCocoa

// source: https://github.com/RxSwiftCommunity/RxSwiftExt

extension ObservableType where E == Bool {
  /// Boolean not operator
  public func not() -> Observable<Bool> {
    return self.map(!)
  }
}

extension SharedSequenceConvertibleType where E == Bool {
  /// Boolean not operator.
  public func not() -> SharedSequence<SharingStrategy, Bool> {
    return map(!)
  }
}
