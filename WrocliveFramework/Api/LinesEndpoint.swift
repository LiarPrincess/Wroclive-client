// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire

public final class LinesEndpoint: JSONEndpoint {
  public var url:               URLConvertible { return AppEnvironment.configuration.endpoints.lines }
  public let method:            HTTPMethod        = .get
  public let parameterEncoding: ParameterEncoding = JSONEncoding.default
  public let headers:           HTTPHeaders?      = ["Accept": "application/json"]

  public typealias ParameterData = Void
  public typealias ResponseData  = [Line]

  public func encodeParameters(_ data: Void) -> Parameters? {
    return nil
  }

  public func decodeResponse(_ data: Data) throws -> ResponseData {
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