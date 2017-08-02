//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

protocol Endpoint {
  var url:               URLConvertible    { get }
  var method:            HTTPMethod        { get }
  var parameterEncoding: ParameterEncoding { get }
  var headers:           HTTPHeaders?      { get }

  associatedtype RequestData
  func encodeParameters(_ data: RequestData) -> Parameters?

  associatedtype ResponseData
  func parseResponse(_ json: Any) -> Promise<ResponseData>
}

// MARK: - Default values

extension Endpoint {
  var method:   HTTPMethod        { return .get }
  var encoding: ParameterEncoding { return URLEncoding.default }
  var headers:  HTTPHeaders?      { return nil }
}

extension Endpoint where RequestData == Void {
  func encodeParameters(_ data: Void) -> Parameters? {
    return nil
  }
}

// MARK: - getDeviceIdentifier

extension Endpoint {

  /// e.g. iOS10.2-E621E1F8-C36C-495A-93FC-0C247A3E6E5F
  func getDeviceIdentifier() -> String {
    let device        = UIDevice.current
    let systemName    = device.systemName
    let systemVersion = device.systemVersion
    let identifier    = device.identifierForVendor?.uuidString ?? device.model
    return systemName + systemVersion + "-" + identifier
  }
}
