//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

class LineRequestSerialization {

  // MARK: - Response

  static func parseResponse(_ jsonData: [[String: Any]]) -> Promise<[Line]> {
    return Promise { fulfill, reject in
      do {
        let lines = try jsonData.map { return try Line($0) }
        fulfill(lines)
      } catch {
        reject(NetworkingError.invalidResponse)
      }
    }
  }

}
