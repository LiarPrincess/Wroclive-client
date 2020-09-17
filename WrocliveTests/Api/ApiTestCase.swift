// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import WrocliveFramework

protocol ApiTestCase {}

extension ApiTestCase {

  func createApi(
    baseUrl: String,
    requestHandler: @escaping MockUrlProtocol.RequestHandler
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
