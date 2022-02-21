// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os.log
import PromiseKit
import WrocliveFramework

// swiftlint:disable static_operator

precedencegroup Precedence { higherThan: AssignmentPrecedence associativity: left }
infix operator ~>: Precedence

/// Basically `Guarantee.then` but with `@autoclosure`.
///
/// It is important that this is for 'Guarantee' and not 'Promise',
/// because we do not want errors in the authorization prompt flow.
private func ~> (
  first: Guarantee<Void>,
  body: @escaping @autoclosure () -> Guarantee<Void>
) -> Guarantee<Void> {
  return first.then(body)
}

internal enum AuthorizationPrompts {

  internal static func showIfNeeded(environment: Environment) {
    let timing = environment.configuration.timing
    let locationAuthorizationPromptDelay = timing.locationAuthorizationPromptDelay
    let notificationPromptDelay = timing.maxWaitingTimeBeforeShowingNotificationPrompt

    // Each function is designed to return imiediatelly if the prompt
    // does not have to be shown.
    //
    // Btw. the other way to do this is to show prompts in reverse order,
    // since the new prompt will always override the previous one.

    _ = after(seconds: locationAuthorizationPromptDelay)
      ~> Self.showUserLocationPromptIfNeeded(environment: environment)
      ~> Self.waitForUserLocationAuthorization(environment: environment,
                                               maxDelay: notificationPromptDelay)
      ~> Self.showNotificationPromptIfNeeded(environment: environment)
  }

  // MARK: - User location

  private static func showUserLocationPromptIfNeeded(
    environment: Environment
  ) -> Guarantee<Void> {
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

    return Guarantee()
  }

  // MARK: - Wait for user location authorization

  private static func waitForUserLocationAuthorization(
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

  // MARK: - Notification

  private static func showNotificationPromptIfNeeded(
    environment: Environment
  ) -> Guarantee<Void> {
    return environment.remoteNotifications.getSettings()
      .then { settings -> Guarantee<Void> in
        let log = environment.log.app
        let authorization = settings.authorization

        switch authorization {
        case .notDetermined,
             .unknownValue:
          os_log("Asking for notification authorization", log: log, type: .info)
          return environment.remoteNotifications.requestAuthorization()
            .asVoid()
            .recover { _ in () }

        case .authorized,
             .provisional,
             .ephemeral,
             .denied:
          os_log("Notification authorization: '%{public}@'",
                 log: log,
                 type: .info,
                 String(describing: authorization))
          return Guarantee()
        }
      }
  }
}
