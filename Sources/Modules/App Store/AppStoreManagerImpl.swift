//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class AppStoreManagerImpl: AppStoreManager {

  var applicationId: String { return "" }

  func buyUpgrade() {
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }

  func restorePurchase() {
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }

  func showRateControl() {
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }
}
