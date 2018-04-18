//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire

class AvailableLinesEndpoint: Endpoint {

  let url:               URLConvertible    = AppInfo.Endpoints.lines
  let method:            HTTPMethod        = .get
  let parameterEncoding: ParameterEncoding = JSONEncoding.default
  let headers:           HTTPHeaders?      = ["Accept": "application/json"]

  typealias ParameterData = Void
  typealias ResponseData  = [Line]

  func decodeResponse(_ data: Data) throws -> ResponseData {
    let model = try self.parseJSON(ResponseModel.self, from: data)
    return try model.data.map(parseLine)
  }
}

// MARK: - Response

private struct ResponseModel: Decodable {
  let timestamp: String
  let data:      [LineModel]

  struct LineModel: Decodable {
    let name:    String
    let type:    String
    let subtype: String
  }
}

private func parseLine(_ model: ResponseModel.LineModel) throws -> Line {
  guard let type    = parseLineType(model.type),
        let subtype = parseLineSubtype(model.subtype)
    else { throw ApiError.invalidResponse }

  return Line(name: model.name, type: type, subtype: subtype)
}

private func parseLineType(_ type: String) -> LineType? {
  switch type.uppercased() {
  case "TRAM": return .tram
  case "BUS" : return .bus
  default:     return nil
  }
}

private func parseLineSubtype(_ subtype: String) -> LineSubtype? {
  switch subtype.uppercased() {
  case "REGULAR":   return .regular
  case "EXPRESS":   return .express
  case "HOUR":      return .peakHour
  case "SUBURBAN":  return .suburban
  case "ZONE":      return .zone
  case "LIMITED":   return .limited
  case "TEMPORARY": return .temporary
  case "NIGHT":     return .night
  default:          return nil
  }
}
