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
      let model         = Managers.device.model
      let systemName    = Managers.device.systemName
      let systemVersion = Managers.device.systemVersion
      return "\(model) \(systemName) \(systemVersion)"
    }()

    let executable = Managers.app.name
    let appVersion = Managers.app.version
    let bundle     = Managers.app.identifier
    return "\(executable)/\(appVersion) (\(bundle); \(deviceOSVersion))"
  }
}
