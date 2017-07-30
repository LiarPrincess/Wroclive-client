//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit
import MapKit
import ReachabilitySwift

fileprivate typealias Constants = NetworkManagerConstants
fileprivate typealias Endpoints = Constants.Endpoints

class NetworkManagerImpl: NetworkManager {

  // MARK: - Properties

  private let reachability = Reachability()

  // MARK: - NetworkingManager

  func getAvailableLines() -> Promise<[Line]> {
    return self.showActivityIndicator()
      .then { _ -> URLDataPromise in
        let url     = URL(string: Endpoints.lines)
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Constants.timeout)
        request.httpMethod = "GET"
        return URLSession.shared.dataTask(with: request)
      }
      .then { response in return response.asArray() }
      .then { responseData -> Promise<[Line]> in
        guard let data = responseData as? [[String: Any]] else {
          return Promise(error: NetworkingError.invalidResponse)
        }
        return LineRequestSerialization.parseResponse(data)
      }
      .recover { return self.recoverError(error: $0) }
  }

  func getVehicleLocations(for lines: [Line]) -> Promise<[VehicleLocation]> {
    return LocationRequestSerialization.createRequest(lines)
      .then { jsonData -> URLDataPromise in
        let url     = URL(string: Endpoints.locations)
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Constants.timeout)
        request.httpMethod = "POST"
        request.httpBody   = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return URLSession.shared.dataTask(with: request)
      }
      .then { response in return response.asArray() }
      .then { responseData -> Promise<[VehicleLocation]> in
        guard let data = responseData as? [[String: Any]] else {
          return Promise(error: NetworkingError.invalidResponse)
        }
        return LocationRequestSerialization.parseResponse(data)
      }
      .recover { return self.recoverError(error: $0) }
  }

  // MARK: - (Private) Activity indicator

  private func showActivityIndicator() -> Promise<Void> {
    return firstly {
        NetworkActivityIndicatorManager.shared.incrementActivityCount()
        return Promise(value: ())
      }
      .always {
        NetworkActivityIndicatorManager.shared.decrementActivityCount()
      }
  }

  // MARK: - (Private) Recover errors

  private func recoverError<T>(error: Error) -> Promise<T> {
    switch error {
    case NetworkingError.invalidResponse: return Promise(error: error)
    default:
      if let reachability = self.reachability, !reachability.isReachable {
        return Promise(error: NetworkingError.noInternet)
      }

      return Promise(error: NetworkingError.connectionError)
    }
  }

}
