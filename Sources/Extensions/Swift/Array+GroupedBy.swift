//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

extension Array {

  func grouped<Key: Hashable>(_ grouping: (Element) -> Key) -> [Key:[Element]] {
    var result: [Key:[Element]] = [:]

    for value in self {
      let key = grouping(value)
      result[key, default: []].append(value)
    }

    return result
  }
}
