// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire

extension HTTPHeaders {

  internal enum Accept: CustomStringConvertible {
    case json

    internal var description: String {
      switch self {
      case .json:
        return "application/json"
      }
    }
  }

  internal enum AcceptEncoding: CustomStringConvertible {
    /// br, gzip, deflate
    case compressed

    internal var description: String {
      switch self {
      case .compressed:
        return "br, gzip, deflate"
      }
    }
  }

  internal init(accept: Accept,
                acceptEncoding: AcceptEncoding) {
    self.init()

    let acceptString = String(describing: accept)
    self.add(name: "Accept", value: acceptString)

    let acceptEncodingString = String(describing: acceptEncoding)
    self.add(name: "Accept-Encoding", value: acceptEncodingString)
  }
}
