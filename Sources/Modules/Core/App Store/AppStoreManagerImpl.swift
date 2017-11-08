//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import UIKit

class AppStoreManagerImpl: AppStoreManager {

  func buyUpgrade() {
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }

  func restorePurchase() {
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }

  func rateApp() {
    UIApplication.shared.open(URL(string: AppInfo.AppStore.writeReviewUrl)!)
  }
}
