//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

class NetworkingManagerImpl: NetworkingManager {

  func getLineDefinitions() -> Promise<[Line]> {
    return self.showActivityIndicator()
      .then { _ -> URLDataPromise in
        let url     = "https://api.myjson.com/bins/veb5z"
        let request = URLRequest(url: URL(string: url)!)
        return URLSession.shared.dataTask(with: request)
      }
      .then { response in return response.asArray() }
      .then { responseData -> Promise<[Line]> in
        guard let data = responseData as? [[String: Any]] else {
          return Promise(error: NetworkingError.invalidResponseFormat)
        }
        return LineParser.parse(data)
      }
  }

  // MARK: - Private - Activity indicator

  private func showActivityIndicator() -> Promise<Void> {
    return firstly {
        NetworkActivityIndicatorManager.shared.incrementActivityCount()
        return Promise(value: ())
      }
      .always {
        NetworkActivityIndicatorManager.shared.decrementActivityCount()
      }
  }

}
