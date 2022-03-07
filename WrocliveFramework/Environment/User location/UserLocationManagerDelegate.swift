// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public protocol UserLocationManagerDelegate: AnyObject {

  /// This will be called:
  /// - When the app is launched for the 1st time with '.notDetermined'
  /// - When the user selects status from prompt
  /// - When the user changes authorization in settings and launches app
  func locationManager(_ manager: UserLocationManagerType,
                       didChangeAuthorization status: UserLocationAuthorization)
}
