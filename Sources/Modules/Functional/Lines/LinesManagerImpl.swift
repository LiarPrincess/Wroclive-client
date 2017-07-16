//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

public class LinesManagerImpl: LinesManager {

// MARK: - Properties

  private let linesCache: LinesCache = {
    let hour: TimeInterval = 3600
    return LinesCache(expirationTime: 6 * hour)
  }()

// MARK: - Get all

  func getAll() -> Promise<[Line]> {
    if let cachedLines = self.linesCache.value {
      return Promise(value: cachedLines)
    }

    return Managers.networking.getLineDefinitions()
      .then { lines -> Promise<[Line]> in
        self.linesCache.put(lines)
        return Promise(value: lines)
      }
  }

}
