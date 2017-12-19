//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire

typealias ResponseParserType = ResponseParser

protocol Endpoint {
  var url:               URLConvertible    { get }
  var method:            HTTPMethod        { get }
  var parameterEncoding: ParameterEncoding { get }
  var headers:           HTTPHeaders?      { get }

  associatedtype RequestData
  func encodeParameters(_ data: RequestData) -> Parameters?

  associatedtype ResponseParser: ResponseParserType
}
