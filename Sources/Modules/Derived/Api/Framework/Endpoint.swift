//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire

typealias ParameterEncoderType = ParameterEncoder
typealias ResponseParserType   = ResponseParser

protocol Endpoint {
  var url:               URLConvertible    { get }
  var method:            HTTPMethod        { get }
  var parameterEncoding: ParameterEncoding { get }
  var headers:           HTTPHeaders?      { get }

  associatedtype ParameterEncoder: ParameterEncoderType
  associatedtype ResponseParser:   ResponseParserType

  typealias ParameterData = ParameterEncoder.ParameterData
  typealias ResponseData  = ResponseParser.ResponseData
}
