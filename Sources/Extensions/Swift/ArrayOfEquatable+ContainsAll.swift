//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

extension Array where Element: Equatable {
  func containsAll(other: [Element]) -> Bool {
    let otherContainsElementThatIDont = other.contains { !self.contains($0) }
    return !otherContainsElementThatIDont
  }
}
