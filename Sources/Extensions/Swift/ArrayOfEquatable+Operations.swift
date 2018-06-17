//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

enum ArrayOperation<Element> {
  case append(element: Element)
  case remove(element: Element)
}

extension Array where Element: Equatable {

  func apply(_ operation: ArrayOperation<Element>) -> [Element] {
    switch operation {
    case let .append(element): return self.appending(element)
    case let .remove(element): return self.removing(element)
    }
  }

  private func appending(_ element: Element) -> [Element] {
    var copy = self
    copy.append(element)
    return copy
  }

  private func removing(_ element: Element) -> [Element] {
    return self.filter { $0 != element }
  }
}
