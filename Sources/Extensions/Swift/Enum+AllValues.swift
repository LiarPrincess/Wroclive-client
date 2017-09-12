//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

// Source: https://theswiftdev.com/2017/01/05/18-swift-gist-generic-allvalues-for-enums/

protocol EnumCollection: Hashable {
  static var allValues: [Self] { get }
}

extension EnumCollection {

  private static var allCases: AnySequence<Self> {
    return AnySequence { () -> AnyIterator<Self> in
      var raw = 0
      return AnyIterator {
        let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
        guard current.hashValue == raw else { return nil }
        raw += 1
        return current
      }
    }
  }

  static var allValues: [Self] {
    return Array(self.allCases)
  }
}
