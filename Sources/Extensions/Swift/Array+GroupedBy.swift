//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

extension Array {

  func groupedBy <K: Hashable> (_ grouping: (Element) -> K) -> [K:[Element]] {
    var result: [K:[Element]] = [:]

    for value in self {
      let key = grouping(value)
      result[key] = result[key] ?? []
      result[key]?.append(value)
    }

    return result
  }
}
