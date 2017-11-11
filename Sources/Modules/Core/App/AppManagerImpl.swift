//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
#if DEBUG
  import SimulatorStatusMagic
#endif

class AppManagerImpl: AppManager {

  func enableStatusBarOverrides() {
    #if DEBUG
      if ProcessInfo.processInfo.environment["Screenshots"] != nil {
        SDStatusBarManager.sharedInstance().enableOverrides()
      }
      else {
        SDStatusBarManager.sharedInstance().disableOverrides()
      }
    #endif
  }

  func openWebsite() {
    let url = URL(string: AppInfo.websiteHttps)!
    UIApplication.shared.open(url)
  }

  func showShareActivity(in viewController: UIViewController) {
    let text  = String(format: Localizable.Share.message, AppInfo.AppStore.shareUrl)
    let items = [text] as [Any]

    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [.assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .openInIBooks, .print]
    viewController.present(activityViewController, animated: true, completion: nil)
  }
}
