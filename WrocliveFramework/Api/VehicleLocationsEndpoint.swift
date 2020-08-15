// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Alamofire

internal struct VehicleLocationsEndpoint: Endpoint {

  internal typealias ParameterData = [Line]
  internal typealias ResponseData = [Vehicle]

  internal var url: URLConvertible
  internal let method: HTTPMethod = .post
  internal let parameterEncoding: ParameterEncoding = JSONEncoding.default
  internal let headers: HTTPHeaders? = ["Accept": "application/json"]

  internal init(configuration: Configuration) {
    self.url = configuration.endpoints.vehicleLocations
  }

  internal func encodeParameters(_ data: [Line]) -> Parameters? {
    var parameters = Parameters()
    parameters["lines"] = data.map(encodeLine)
    return parameters
  }

  internal func decodeResponse(_ data: Data) throws -> ResponseData {
    let model = try self.parseJSON(ResponseModel.self, from: data)
    return try model.data.flatMap(parseVehicleLocations)
  }
}

// MARK: - Request

private func encodeLine(_ line: Line) -> [String: Any] {
  return [
    "name": line.name,
    "type": encodeLineType(line.type)
  ]
}

private func encodeLineType(_ type: LineType) -> String {
  switch type {
  case .bus: return "bus"
  case .tram: return "tram"
  }
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
  let line = try parseLine(model.line)
  return model.vehicles.map {
    Vehicle(id: $0.id,
            line: line,
            latitude: $0.lat,
            longitude: $0.lng,
            angle: $0.angle)
  }
}

private func parseLine(_ model: LineModel) throws -> Line {
  guard let type = parseLineType(model.type),
        let subtype = parseLineSubtype(model.subtype)
    else { throw ApiError.invalidResponse }

  return Line(name: model.name, type: type, subtype: subtype)
}

private func parseLineType(_ type: String) -> LineType? {
  switch type.uppercased() {
  case "TRAM": return .tram
  case "BUS": return .bus
  default: return nil
  }
}

private func parseLineSubtype(_ subtype: String) -> LineSubtype? {
  switch subtype.uppercased() {
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
