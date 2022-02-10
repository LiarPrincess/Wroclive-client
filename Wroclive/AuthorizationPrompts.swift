// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os.log
import PromiseKit
import WrocliveFramework

internal enum AuthorizationPrompts {

  // MARK: - User location

  internal static func askForUserLocationAuthorization(environment: Environment) {
    let delay = environment.configuration.timing.locationAuthorizationPromptDelay
    after(seconds: delay)
      .done { _ in
        let log = environment.log.app
        let status = environment.userLocation.getAuthorizationStatus()

        switch status {
        case .notDetermined,
             .unknownValue:
          os_log("Asking for user location authorization", log: log, type: .info)
          environment.userLocation.requestWhenInUseAuthorization()

        case .authorized,
             .restricted,
             .denied:
          os_log("User location authorization: '%{public}@'",
                 log: log,
                 type: .info,
                 String(describing: status))
        }
      }
  }

  // MARK: - Notification

  internal static func askForNotificationAuthorization(environment: Environment) {
    let maxDelay: TimeInterval = 10.0

    // We want to show notification prompt AFTER location prompt!
    self.waitWhileLocationAuthorizationIsNotDetermined(environment: environment,
                                                       maxDelay: maxDelay)
      .then(environment.notification.getSettings)
      .then { settings -> Promise<Void> in
        let log = environment.log.app
        let authorization = settings.authorization

        switch authorization {
        case .notDetermined,
             .unknownValue:
          os_log("Asking for notification authorization", log: log, type: .info)
          return environment.notification.requestAuthorization().asVoid()

        case .authorized,
             .provisional,
             .ephemeral,
             .denied:
          os_log("Notification authorization: '%{public}@'",
                 log: log,
                 type: .info,
                 String(describing: authorization))
          return Promise()
        }
      }
      .cauterize()
  }

  private static func waitWhileLocationAuthorizationIsNotDetermined(
    environment: Environment,
    maxDelay: TimeInterval
  ) -> Guarantee<Void> {
    return Self.waitWhileLocationAuthorizationIsNotDeterminedRec(
      environment: environment,
      remainingTime: maxDelay
    )
  }

  private static func waitWhileLocationAuthorizationIsNotDeterminedRec(
    environment: Environment,
    remainingTime: TimeInterval
  ) -> Guarantee<Void> {
    let status = environment.userLocation.getAuthorizationStatus()

    switch status {
    case .notDetermined:
      // 'notDetermined' -> more waiting.
      break
    case .authorized,
         .restricted,
         .denied:
      // All of those are determined.
      return Guarantee()
    case .unknownValue:
      // Hard to tell, we will just assume that this is determined.
      return Guarantee()
    }

    let timeIncrement: TimeInterval = 1
    let remainingTimeAfterIncrement = remainingTime - timeIncrement

    let hasNoRemainingTime = remainingTimeAfterIncrement < 0
    if hasNoRemainingTime {
      return Guarantee()
    }

    // Wait 'timeIncrement' and dispatch ourselves again.
    return after(seconds: timeIncrement).then { _ in
      return Self.waitWhileLocationAuthorizationIsNotDeterminedRec(
        environment: environment,
        remainingTime: remainingTimeAfterIncrement
      )
    }
  }
}
