//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class LinesCache {

  // MARK: - Properties

  let expirationTime: TimeInterval

  private var lines      = [Line]()
  private var updateTime = Date.distantPast

  // MARK: - Init

  init(expirationTime: TimeInterval) {
    self.expirationTime = expirationTime
  }

  var value: [Line]? {
    let now = Date()
    let timeSinceUpdate = now.timeIntervalSince(updateTime)

    let isExpired = timeSinceUpdate > self.expirationTime
    return isExpired ? nil : self.lines
  }

  // MARK: - Methods

  final func put(_ lines: [Line]) {
    self.updateTime = Date()
    self.lines      = lines
  }

}
