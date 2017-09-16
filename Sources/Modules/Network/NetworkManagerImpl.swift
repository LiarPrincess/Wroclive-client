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

  private lazy var session      = SessionManager()
  private lazy var reachability = Alamofire.NetworkReachabilityManager(host: "www.google.com")

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

  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    let endpoint = VehicleLocationEndpoint()
    return self.sendRequest(endpoint: endpoint, data: lines)
  }

  // MARK: - Private - Send request

  func sendRequest<TEndpoint: Endpoint>(endpoint: TEndpoint, data: TEndpoint.RequestData) -> Promise<TEndpoint.ResponseData> {
    return self.session
      .request(endpoint: endpoint, data: data)
      .recover { return self.recover($0) }
  }

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
