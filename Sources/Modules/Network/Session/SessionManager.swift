//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class SessionManager: Alamofire.SessionManager {

  // MARK: - Init

  init() {
    var headers = Alamofire.SessionManager.defaultHTTPHeaders
    headers["User-Agent"] = SessionManager.createUserAgentString()

    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = headers

    super.init(configuration: configuration)
  }

  // MARK: - Private - Send request

  func request<TEndpoint: Endpoint>(endpoint: TEndpoint, data: TEndpoint.RequestData) -> Promise<TEndpoint.ResponseData> {
    return self.request(
        endpoint.url,
        method:     endpoint.method,
        parameters: endpoint.encodeParameters(data),
        encoding:   endpoint.parameterEncoding,
        headers:    endpoint.headers
      )
      .validate()
      .responseJSON()
      .then { return endpoint.decodeResponse($0) }
  }

  // MARK: - Private - User agent

  // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
  // Example: 'Kek/1.0 (com.kekapp.kek; iPhone iOS 10.3.1)'
  private static func createUserAgentString() -> String {
    let deviceOSVersion: String = {
      let model         = Managers.device.model
      let systemName    = Managers.device.systemName
      let systemVersion = Managers.device.systemVersion
      return "\(model) \(systemName) \(systemVersion)"
    }()

    let executable = Managers.app.name
    let appVersion = Managers.app.version
    let bundle     = Managers.app.bundle
    return "\(executable)/\(appVersion) (\(bundle); \(deviceOSVersion))"
  }
}