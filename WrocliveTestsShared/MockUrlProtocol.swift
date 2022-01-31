// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public struct DummyApiError: Error {
  public init() { }
}

// See: https://developer.apple.com/videos/play/wwdc2018/417/
public final class MockUrlProtocol: URLProtocol {

  public typealias RequestHandler = (URLRequest) throws -> (HTTPURLResponse, Data)

  public static var requestHandler: RequestHandler?

  public override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  public override func startLoading() {
    guard let handler = Self.requestHandler else {
      fatalError("Received unexpected request with no handler set")
    }

    do {
      let (response, data) = try handler(request)
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: data)
      client?.urlProtocolDidFinishLoading(self)
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }

  public override func stopLoading() {}
}
