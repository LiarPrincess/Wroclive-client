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
    headers["User-Agent"] = SessionManager.userAgentString

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
  // Example: 'Wroclive/1.0 (pl.nopoint.wroclive; iPhone iOS 10.3.1)'
  private static var userAgentString: String {
    let model         = Managers.device.model
    let systemName    = Managers.device.systemName
    let systemVersion = Managers.device.systemVersion
    let deviceOSVersion = "\(model) \(systemName) \(systemVersion)"

    let executable = Managers.bundle.name
    let appVersion = Managers.bundle.version
    let bundle     = Managers.bundle.identifier
    return "\(executable)/\(appVersion) (\(bundle); \(deviceOSVersion))"
  }
}
