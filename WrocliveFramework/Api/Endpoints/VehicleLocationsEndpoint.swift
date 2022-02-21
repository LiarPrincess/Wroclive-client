// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import Alamofire

internal struct VehicleLocationsEndpoint: Endpoint {

  internal typealias ParameterData = [Line]
  internal typealias ResponseData = [Vehicle]

  internal let url: URLConvertible
  internal let method = HTTPMethod.get
  internal let parameterEncoding: ParameterEncoding = URLEncoding.queryString
  internal let headers = HTTPHeaders(accept: .json, acceptEncoding: .compressed)
  private let log: OSLog

  internal init(baseUrl: String, log: OSLog) {
    self.url = baseUrl.appendingPathComponent("/vehicles")
    self.log = log
  }

  internal func encodeParameters(_ data: [Line]) -> Parameters? {
    var parameters = Parameters()
    parameters["lines"] = encode(lines: data)
    return parameters
  }

  internal func decodeResponse(_ data: Data) throws -> ResponseData {
    let responseModel = try self.parseJSON(ResponseModel.self, from: data)
    let mapResult = self.compactMap(models: responseModel.data, fn: parseVehicleLocations(_:))

    switch mapResult {
    case .noModels:
      return []
    case .success(let vehicles):
      return vehicles
    case .partialSuccess(let vehicles):
      // Some of them failed, but it is better than nothing.
      os_log("[GetVehicleLocationsEndpoint] Partial parsing success", log: self.log, type: .debug)
      return vehicles
    case .allFailed:
      throw ApiError.invalidResponse
    }
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

// swiftlint:disable:next discouraged_optional_collection
private func parseVehicleLocations(_ model: LineLocationModel) -> [Vehicle]? {
  guard let line = parseLine(model: model.line) else {
    return nil
  }

  return model.vehicles.map {
    Vehicle(id: $0.id,
            line: line,
            latitude: $0.lat,
            longitude: $0.lng,
            angle: $0.angle)
  }
}

private func parseLine(model: LineModel) -> Line? {
  guard let type = parseLineType(model: model.type),
        let subtype = parseLineSubtype(model: model.subtype) else {
    return nil
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
