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
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Constants.timeout)
        return URLSession.shared.dataTask(with: request)
      }
      .then { response in return response.asArray() }
      .then { responseData -> Promise<[Line]> in
        guard let data = responseData as? [[String: Any]] else {
          return Promise(error: NetworkingError.invalidResponse)
        }
        return LineParser.parse(data)
      }
      .recover { error -> Promise<[Line]> in
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

  func getVehicleLocations(for lines: [Line]) -> Promise<[VehicleLocation]> {
    let line = Line(name: "A", type: .bus, subtype: .express)

    let loc0 = CLLocationCoordinate2D(latitude: 51.109524, longitude: 17.02)
    let loc1 = CLLocationCoordinate2D(latitude: 51.109524, longitude: 17.03)
    let loc2 = CLLocationCoordinate2D(latitude: 51.109524, longitude: 17.04)

    let vehicle0  = VehicleLocation(line: line, location: loc0, angle:   0.0)
    let vehicle1  = VehicleLocation(line: line, location: loc1, angle:  90.0)
    let vehicle2  = VehicleLocation(line: line, location: loc2, angle: 180.0)

    return Promise(value: [vehicle0, vehicle1, vehicle2])
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

}
