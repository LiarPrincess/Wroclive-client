//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import UIKit

class AppStoreManagerImpl: AppStoreManager {

  var applicationId: String { return "888422857" }

  func buyUpgrade() {
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }

  func restorePurchase() {
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }

  func rateApp() {
    let appStoreUrl = "itms-apps://itunes.apple.com/us/app/id\(self.applicationId)?action=write-review&mt=8"
    UIApplication.shared.open(URL(string: appStoreUrl)!)
  }
}
