// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
@testable import WrocliveFramework

// MARK: - Test case

public protocol ApiTestCase {}

extension ApiTestCase {

  public typealias RequestHandler = (URLRequest) throws -> (HTTPURLResponse, Data)

  /// See: https://developer.apple.com/videos/play/wwdc2018/417/
  public func createApi(
    baseUrl: String,
    requestHandler: @escaping RequestHandler
  ) -> Api {
    let bundle = BundleManagerMock()
    let device = DeviceManagerMock()
    let log = LogManager(bundle: bundle)

    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockUrlProtocol.self]
    let network = Network(configuration: configuration)

    MockUrlProtocol.requestHandler = requestHandler

    return Api(baseUrl: baseUrl,
               network: network,
               bundle: bundle,
               device: device,
               log: log)
  }
}

// MARK: - URLProtocol

fileprivate final class MockUrlProtocol: URLProtocol {

  fileprivate typealias RequestHandler = (URLRequest) throws -> (HTTPURLResponse, Data)

  fileprivate static var requestHandler: RequestHandler?

  fileprivate override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  fileprivate override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  fileprivate override func startLoading() {
    guard let handler = Self.requestHandler else {
      fatalError("Received unexpected request with no handler set")
    }

    do {
      let (response, data) = try handler(request)
      self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      self.client?.urlProtocol(self, didLoad: data)
      self.client?.urlProtocolDidFinishLoading(self)
    } catch {
      self.client?.urlProtocol(self, didFailWithError: error)
    }
  }

  fileprivate override func stopLoading() {}
}
