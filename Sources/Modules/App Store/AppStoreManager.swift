//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol AppStoreManager {

  /// App Store application id
  var applicationId: String { get }

  /// Start purchase procedure
  func buyUpgrade()

  /// Start purchase restoration procedure
  func restorePurchase()

  /// Asks user to rate app
  func showRateControl()
}
