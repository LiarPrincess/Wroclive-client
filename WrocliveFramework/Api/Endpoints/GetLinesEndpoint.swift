// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
import Alamofire

internal struct GetLinesEndpoint: Endpoint {

  internal typealias ParameterData = Void
  internal typealias ResponseData = [Line]

  internal let url: URLConvertible
  internal let method = HTTPMethod.get
  internal let parameterEncoding: ParameterEncoding = JSONEncoding.default
  internal let headers = HTTPHeaders(accept: .json, acceptEncoding: .compressed)
  private let log: OSLog

  internal init(baseUrl: String, log: OSLog) {
    self.url = baseUrl.appendingPathComponent("/lines")
    self.log = log
  }

  internal func encodeParameters(_ data: Void) -> Parameters? {
    return nil
  }

  internal func decodeResponse(_ data: Data) throws -> ResponseData {
    let responseModel = try self.parseJSON(ResponseModel.self, from: data)
    let mapResult = self.map(models: responseModel.data, fn: parseLine(model:))

    switch mapResult {
    case .noModels:
      // It should not happen, but we all know how it is...
      os_log("[GetLinesEndpoint] Empty response - using predefined", log: self.log, type: .error)
      return predefinedLines
    case .success(let lines):
      return lines
    case .partialSuccess(let lines):
      // Some of them failed, but it is better than nothing.
      os_log("[GetLinesEndpoint] Partial parsing success", log: self.log, type: .error)
      return lines
    case .allFailed:
      throw ApiError.invalidResponse
    }
  }
}

// MARK: - Response

private struct ResponseModel: Decodable {
  let timestamp: String
  let data: [LineModel]
}

private struct LineModel: Decodable {
  let name: String
  let type: String
  let subtype: String
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

// MARK: - Predefined lines

private let predefinedLines = [
  Line(name: "A", type: .bus, subtype: .express),
  Line(name: "C", type: .bus, subtype: .express),
  Line(name: "D", type: .bus, subtype: .express),
  Line(name: "K", type: .bus, subtype: .express),
  Line(name: "N", type: .bus, subtype: .express),
  Line(name: "1", type: .tram, subtype: .regular),
  Line(name: "2", type: .tram, subtype: .regular),
  Line(name: "4", type: .tram, subtype: .regular),
  Line(name: "5", type: .tram, subtype: .regular),
  Line(name: "6", type: .tram, subtype: .regular),
  Line(name: "7", type: .tram, subtype: .regular),
  Line(name: "8", type: .tram, subtype: .regular),
  Line(name: "9", type: .tram, subtype: .regular),
  Line(name: "10", type: .tram, subtype: .regular),
  Line(name: "11", type: .tram, subtype: .regular),
  Line(name: "15", type: .tram, subtype: .regular),
  Line(name: "16", type: .tram, subtype: .regular),
  Line(name: "17", type: .tram, subtype: .regular),
  Line(name: "20", type: .tram, subtype: .regular),
  Line(name: "23", type: .tram, subtype: .regular),
  Line(name: "3", type: .tram, subtype: .regular),
  Line(name: "31", type: .tram, subtype: .regular),
  Line(name: "33", type: .tram, subtype: .regular),
  Line(name: "100", type: .bus, subtype: .regular),
  Line(name: "101", type: .bus, subtype: .regular),
  Line(name: "102", type: .bus, subtype: .regular),
  Line(name: "103", type: .bus, subtype: .regular),
  Line(name: "104", type: .bus, subtype: .regular),
  Line(name: "105", type: .bus, subtype: .regular),
  Line(name: "106", type: .bus, subtype: .regular),
  Line(name: "107", type: .bus, subtype: .regular),
  Line(name: "108", type: .bus, subtype: .regular),
  Line(name: "109", type: .bus, subtype: .regular),
  Line(name: "110", type: .bus, subtype: .regular),
  Line(name: "111", type: .bus, subtype: .regular),
  Line(name: "112", type: .bus, subtype: .regular),
  Line(name: "113", type: .bus, subtype: .regular),
  Line(name: "114", type: .bus, subtype: .regular),
  Line(name: "115", type: .bus, subtype: .regular),
  Line(name: "116", type: .bus, subtype: .regular),
  Line(name: "117", type: .bus, subtype: .regular),
  Line(name: "118", type: .bus, subtype: .regular),
  Line(name: "119", type: .bus, subtype: .regular),
  Line(name: "120", type: .bus, subtype: .regular),
  Line(name: "121", type: .bus, subtype: .regular),
  Line(name: "122", type: .bus, subtype: .regular),
  Line(name: "123", type: .bus, subtype: .regular),
  Line(name: "124", type: .bus, subtype: .regular),
  Line(name: "125", type: .bus, subtype: .regular),
  Line(name: "126", type: .bus, subtype: .regular),
  Line(name: "127", type: .bus, subtype: .regular),
  Line(name: "128", type: .bus, subtype: .regular),
  Line(name: "129", type: .bus, subtype: .regular),
  Line(name: "130", type: .bus, subtype: .regular),
  Line(name: "131", type: .bus, subtype: .regular),
  Line(name: "132", type: .bus, subtype: .regular),
  Line(name: "133", type: .bus, subtype: .regular),
  Line(name: "134", type: .bus, subtype: .regular),
  Line(name: "136", type: .bus, subtype: .regular),
  Line(name: "137", type: .bus, subtype: .regular),
  Line(name: "138", type: .bus, subtype: .regular),
  Line(name: "140", type: .bus, subtype: .regular),
  Line(name: "142", type: .bus, subtype: .regular),
  Line(name: "143", type: .bus, subtype: .regular),
  Line(name: "144", type: .bus, subtype: .regular),
  Line(name: "145", type: .bus, subtype: .regular),
  Line(name: "146", type: .bus, subtype: .regular),
  Line(name: "147", type: .bus, subtype: .regular),
  Line(name: "148", type: .bus, subtype: .regular),
  Line(name: "149", type: .bus, subtype: .regular),
  Line(name: "150", type: .bus, subtype: .regular),
  Line(name: "151", type: .bus, subtype: .regular),
  Line(name: "206", type: .bus, subtype: .night),
  Line(name: "240", type: .bus, subtype: .night),
  Line(name: "241", type: .bus, subtype: .night),
  Line(name: "242", type: .bus, subtype: .night),
  Line(name: "243", type: .bus, subtype: .night),
  Line(name: "244", type: .bus, subtype: .night),
  Line(name: "245", type: .bus, subtype: .night),
  Line(name: "246", type: .bus, subtype: .night),
  Line(name: "247", type: .bus, subtype: .night),
  Line(name: "248", type: .bus, subtype: .night),
  Line(name: "249", type: .bus, subtype: .night),
  Line(name: "250", type: .bus, subtype: .night),
  Line(name: "251", type: .bus, subtype: .night),
  Line(name: "253", type: .bus, subtype: .night),
  Line(name: "255", type: .bus, subtype: .night),
  Line(name: "257", type: .bus, subtype: .night),
  Line(name: "259", type: .bus, subtype: .night),
  Line(name: "315", type: .bus, subtype: .regular),
  Line(name: "319", type: .bus, subtype: .regular),
  Line(name: "345", type: .bus, subtype: .regular),
  Line(name: "602", type: .bus, subtype: .suburban),
  Line(name: "607", type: .bus, subtype: .suburban),
  Line(name: "612", type: .bus, subtype: .suburban),
  Line(name: "722", type: .bus, subtype: .temporary),
  Line(name: "927L", type: .bus, subtype: .regular),
  Line(name: "927P", type: .bus, subtype: .regular)
]
