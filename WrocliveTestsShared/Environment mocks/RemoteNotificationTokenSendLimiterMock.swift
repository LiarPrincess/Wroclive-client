// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Foundation
@testable import WrocliveFramework

public struct DeviceIdTokenPair: Equatable {
  public let deviceId: UUID
  public let token: String

  public init(deviceId: UUID, token: String) {
    self.deviceId = deviceId
    self.token = token
  }
}

public final class RemoteNotificationTokenSendLimiterMock: RemoteNotificationTokenSendLimiterType {

  public init() {}

  public var shouldSendResult = false
  public private(set) var shouldSendTokenArg: DeviceIdTokenPair?
  public private(set) var shouldSendCallCount = 0

  public func shouldSend(deviceId: UUID, token: String) -> Bool {
    self.shouldSendCallCount += 1
    self.shouldSendTokenArg = DeviceIdTokenPair(deviceId: deviceId, token: token)
    return self.shouldSendResult
  }

  public private(set) var registerSendCallCount = 0
  public private(set) var registerSendTokenArg: DeviceIdTokenPair?

  public func registerSend(deviceId: UUID,token: String) {
    self.registerSendCallCount += 1
    self.registerSendTokenArg = DeviceIdTokenPair(deviceId: deviceId, token: token)
  }
}
