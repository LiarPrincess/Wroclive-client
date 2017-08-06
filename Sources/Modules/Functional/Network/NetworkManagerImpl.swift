//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityIndicator
import PromiseKit

typealias JSONDictionary =  [String : AnyObject]
typealias JSONArray      = [[String : AnyObject]]

class NetworkManagerImpl: NetworkManager {

  // MARK: - Properties

  private let reachability = Alamofire.NetworkReachabilityManager(host: "www.google.com")

  // MARK: - Init

  init() {
    NetworkActivityIndicatorManager.shared.isEnabled = true
    self.reachability?.startListening()
  }

  // MARK: - NetworkManager

  func getAvailableLines() -> Promise<[Line]> {
    let endpoint = AvailableLinesEndpoint()
    return self.sendRequest(endpoint: endpoint, data: ())
  }

  func getVehicleLocations(for lines: [Line]) -> Promise<[VehicleLocation]> {
    let endpoint = VehicleLocationEndpoint()
    return self.sendRequest(endpoint: endpoint, data: lines)
  }

  func sendRequest<TEndpoint: Endpoint>(endpoint: TEndpoint, data: TEndpoint.RequestData) -> Promise<TEndpoint.ResponseData> {
    return Alamofire.request(
      endpoint.url,
      method:     endpoint.method,
      parameters: endpoint.encodeParameters(data),
      encoding:   endpoint.parameterEncoding,
      headers:    endpoint.headers
    )
    .validate()
    .responseJSON()
    .then { return endpoint.parseResponse($0) }
    .recover { return self.recover($0) }
  }

  // MARK: - Private - Recover errors

  private func recover<T>(_ error: Error) -> Promise<T> {
    switch error {
    case NetworkError.invalidResponse: return Promise(error: error)
    default:
      let isReachable = self.reachability?.isReachable ?? true
      if !isReachable {
        return Promise(error: NetworkError.noInternet)
      }

      return Promise(error: NetworkError.connectionError)
    }
  }

}
