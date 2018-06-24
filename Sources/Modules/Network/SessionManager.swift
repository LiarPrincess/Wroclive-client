// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
      let model         = AppEnvironment.current.device.model
      let systemName    = AppEnvironment.current.device.systemName
      let systemVersion = AppEnvironment.current.device.systemVersion
      return "\(model) \(systemName) \(systemVersion)"
    }()

    let executable = AppEnvironment.current.bundle.name
    let appVersion = AppEnvironment.current.bundle.version
    let bundle     = AppEnvironment.current.bundle.identifier
    return "\(executable)/\(appVersion) (\(bundle); \(deviceOSVersion))"
  }
}
