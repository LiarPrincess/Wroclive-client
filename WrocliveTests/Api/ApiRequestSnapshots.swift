// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import SnapshotTesting
@testable import WrocliveFramework

private typealias Constants = CardContainer.Constants

// See: https://developer.apple.com/videos/play/wwdc2018/417/
class ApiRequestSnapshots: XCTestCase, SnapshotTestCase {

  // MARK: - Lines

  func test_lines() {
    let api = self.createApi(baseUrl: "API_URL") { request in
      self.assertSnapshot(matching: request, as: .raw)
      throw IgnoreThisError()
    }

    let expectation = XCTestExpectation(description: "response")
    _ = api.getLines().catch { _ in
      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }

  // MARK: - Vehicle locations

  func test_vehicleLocations_1() {
    let api = self.createApi(baseUrl: "API_URL") { request in
      self.assertSnapshot(matching: request, as: .raw)
      throw IgnoreThisError()
    }

    let lines = [
      Line(name: "A", type: .bus, subtype: .express),
      Line(name: "4", type: .tram, subtype: .express)
    ]

    let expectation = XCTestExpectation(description: "response")
    _ = api.getVehicleLocations(for: lines).catch { _ in
      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }

  func test_vehicleLocations_2() {
    let api = self.createApi(baseUrl: "API_URL") { request in
      self.assertSnapshot(matching: request, as: .raw)
      throw IgnoreThisError()
    }

    let lines = [
      Line(name: "A", type: .bus, subtype: .express),
      Line(name: "D", type: .bus, subtype: .express),
      Line(name: "0P", type: .tram, subtype: .regular),
      Line(name: "0L", type: .tram, subtype: .regular),
      Line(name: "4", type: .tram, subtype: .regular),
      Line(name: "20", type: .tram, subtype: .regular),
      Line(name: "31", type: .tram, subtype: .regular),
      Line(name: "32", type: .tram, subtype: .regular),
      Line(name: "107", type: .bus, subtype: .regular),
      Line(name: "124", type: .bus, subtype: .regular),
      Line(name: "125", type: .bus, subtype: .regular),
      Line(name: "250", type: .bus, subtype: .night),
      Line(name: "251", type: .bus, subtype: .night),
      Line(name: "325", type: .bus, subtype: .regular),
      Line(name: "602", type: .bus, subtype: .suburban),
      Line(name: "607", type: .bus, subtype: .suburban)
    ]

    let expectation = XCTestExpectation(description: "response")
    _ = api.getVehicleLocations(for: lines).catch { _ in
      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }

  // MARK: - Helpers

  private func createApi(baseUrl: String,
                         requestHandler: @escaping RequestHandler) -> Api {
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

// MARK: - IgnoreThisError

private struct IgnoreThisError: Error { }

// MARK: - MockUrlProtocol

private typealias RequestHandler = (URLRequest) throws -> (HTTPURLResponse, Data)

private final class MockUrlProtocol: URLProtocol {

  static var requestHandler: RequestHandler?

  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  override func startLoading() {
    guard let handler = Self.requestHandler else {
      XCTFail("Received unexpected request with no handler set")
      return
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

  override func stopLoading() {}
}
