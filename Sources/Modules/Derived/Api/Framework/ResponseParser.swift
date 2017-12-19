//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

protocol ResponseParser {
  associatedtype ResponseData
  static func parse(_ data: Data) throws -> ResponseData
}

protocol JSONResponseParser: ResponseParser {
  associatedtype JSONModel: Decodable
  static func map(_ model: JSONModel) throws -> ResponseData
}

extension JSONResponseParser {
  static func parse(_ data: Data) throws -> ResponseData {
    return try map(try self.parseModel(data))
  }

  private static func parseModel(_ data: Data) throws -> JSONModel {
    do {
      let decoder = JSONDecoder()
      return try decoder.decode(JSONModel.self, from: data)
    }
    catch {
      throw ApiError.invalidResponse
    }
  }
}
