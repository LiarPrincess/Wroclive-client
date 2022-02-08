// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire

internal struct VehicleLocationsEndpoint: Endpoint {

  internal typealias ParameterData = [Line]
  internal typealias ResponseData = [Vehicle]

  internal let url: URLConvertible
  internal let method = HTTPMethod.get
  internal let parameterEncoding: ParameterEncoding = URLEncoding.queryString
  internal let headers = HTTPHeaders(accept: .json, acceptEncoding: .compressed)

  internal init(baseUrl: String) {
    self.url = baseUrl.appendingPathComponent("/vehicles")
  }

  internal func encodeParameters(_ data: [Line]) -> Parameters? {
    var parameters = Parameters()
    parameters["lines"] = encode(lines: data)
    return parameters
  }

  internal func decodeResponse(_ data: Data) throws -> ResponseData {
    let model = try self.parseJSON(ResponseModel.self, from: data)
    return try model.data.flatMap(parseVehicleLocations)
  }
}

// MARK: - Request

private func encode(lines: [Line]) -> String {
  // This is basically 'lines.map { $0.name }.joined(separator: ";")',
  // but a tiny bit more optimized.

  var result = ""
  result.reserveCapacity(lines.count * 3) // 2 for line and 1 for ';'

  for (index, line) in lines.enumerated() {
    result.append(line.name)

    let isLast = index == lines.count - 1
    if !isLast {
      result.append(";")
    }
  }

  return result
}

// MARK: - Response

private struct ResponseModel: Decodable {
  let timestamp: String
  let data: [LineLocationModel]
}

private struct LineLocationModel: Decodable {
  let line: LineModel
  let vehicles: [VehicleModel]
}

private struct LineModel: Decodable {
  let name: String
  let type: String
  let subtype: String
}

private struct VehicleModel: Decodable {
  let id: String
  let lat: Double
  let lng: Double
  let angle: Double
}

private func parseVehicleLocations(_ model: LineLocationModel) throws -> [Vehicle] {
  let line = try parseLine(model: model.line)
  return model.vehicles.map {
    Vehicle(id: $0.id,
            line: line,
            latitude: $0.lat,
            longitude: $0.lng,
            angle: $0.angle)
  }
}

private func parseLine(model: LineModel) throws -> Line {
  guard let type = parseLineType(model: model.type),
        let subtype = parseLineSubtype(model: model.subtype) else {
    throw ApiError.invalidResponse
  }

  return Line(name: model.name, type: type, subtype: subtype)
}

private func parseLineType(model: String) -> LineType? {
  switch model.uppercased() {
  case "TRAM": return .tram
  case "BUS": return .bus
  default: return nil
  }
}

private func parseLineSubtype(model: String) -> LineSubtype? {
  switch model.uppercased() {
  case "REGULAR": return .regular
  case "EXPRESS": return .express
  case "HOUR": return .peakHour
  case "SUBURBAN": return .suburban
  case "ZONE": return .zone
  case "LIMITED": return .limited
  case "TEMPORARY": return .temporary
  case "NIGHT": return .night
  default: return nil
  }
}
