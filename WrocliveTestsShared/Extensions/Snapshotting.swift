// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
import SnapshotTesting
import WrocliveFramework

extension Snapshotting where Value == URLRequest, Format == String {

  public static func request(pretty: Bool) -> Snapshotting {
    return SimplySnapshotting.lines.pullback { (request: URLRequest) in
      let method = "\(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "(null)")"

      let headers = (request.allHTTPHeaderFields ?? [:])
        .map { key, value in "\(key): \(value)" }
        .sorted()

      let bodyData = getBody(request: request)
      let body = bodyData.map { formatBody(data: $0, pretty: pretty) } ?? []

      return ([method] + headers + body).joined(separator: "\n")
    }
  }
}

private func getBody(request: URLRequest) -> Data? {
  if let body = request.httpBody {
    return body
  }

  if let stream = request.httpBodyStream {
    let bufferSize = 100
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)

    var result = Data()
    stream.open()

    while stream.hasBytesAvailable {
      let count = stream.read(buffer, maxLength: bufferSize)
      result.append(buffer, count: count)
    }

    stream.close()
    buffer.deallocate()
    return result
  }

  return nil
}

private func formatBody(data: Data, pretty: Bool) -> [String] {
  do {
    if pretty, #available(iOS 11.0, macOS 10.13, tvOS 11.0, *) {
      let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
      let pretty = try JSONSerialization.data(
        withJSONObject: jsonObject,
        options: [.prettyPrinted, .sortedKeys]
      )

      let decoded = String(decoding: pretty, as: UTF8.self)
      return ["\n\(decoded)"]
    } else {
      throw NSError(domain: "co.pointfree.Never", code: 1, userInfo: nil)
    }
  } catch {
    let decoded = String(decoding: data, as: UTF8.self)
    return ["\n\(decoded)"]
  }
}
