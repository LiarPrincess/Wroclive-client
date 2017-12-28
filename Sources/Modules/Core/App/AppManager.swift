//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class AppManager: AppManagerType {

  var name:       String { return self.bundleInformation(key: kCFBundleExecutableKey as String) ?? "Unknown" }
  var version:    String { return self.bundleInformation(key: "CFBundleShortVersionString")     ?? "0" }
  var identifier: String { return self.bundleInformation(key: kCFBundleIdentifierKey as String) ?? "Unknown" }

  private func bundleInformation(key: String) -> String? {
    return Bundle.main.infoDictionary?[key] as? String
  }

  func rateApp() {
    UIApplication.shared.open(URL(string: AppInfo.AppStore.writeReviewUrl)!)
  }

  func showShareActivity(in viewController: UIViewController) {
    let text  = String(format: Localizable.Share.message, AppInfo.AppStore.shareUrl)
    let image = Assets.shareImage
    let items = [text, image] as [Any]

    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [.assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .openInIBooks, .print]
    viewController.present(activityViewController, animated: true, completion: nil)
  }

  func openWebsite() {
    let url = URL(string: AppInfo.websiteHttps)!
    UIApplication.shared.open(url)
  }
}
