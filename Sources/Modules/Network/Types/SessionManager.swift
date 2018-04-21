//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire

class SessionManager: Alamofire.SessionManager {

  init() {
    var headers = Alamofire.SessionManager.defaultHTTPHeaders
    headers["User-Agent"] = SessionManager.userAgentString

    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = headers
    super.init(configuration: configuration)
  }

  // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
  // Example: 'Wroclive/1.0 (pl.nopoint.wroclive; iPhone iOS 10.3.1)'
  private static var userAgentString: String {
    let deviceOSVersion: String = {
      let model         = AppEnvironment.device.model
      let systemName    = AppEnvironment.device.systemName
      let systemVersion = AppEnvironment.device.systemVersion
      return "\(model) \(systemName) \(systemVersion)"
    }()

    let executable = AppEnvironment.bundle.name
    let appVersion = AppEnvironment.bundle.version
    let bundle     = AppEnvironment.bundle.identifier
    return "\(executable)/\(appVersion) (\(bundle); \(deviceOSVersion))"
  }
}
