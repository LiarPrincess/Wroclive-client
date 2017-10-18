//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Localization = Localizable.App

class AppManagerImpl: AppManager {

  // MARK: - Info

  var name:    String { return self.bundleInformation(key: kCFBundleExecutableKey as String) ?? "" }
  var version: String { return self.bundleInformation(key: "CFBundleShortVersionString")     ?? "" }
  var bundle:  String { return self.bundleInformation(key: kCFBundleIdentifierKey as String) ?? "" }

  private func bundleInformation(key: String) -> String? {
    return Bundle.main.infoDictionary?[key] as? String
  }

  // MARK: - Website

  func openWebsite() {
    UIApplication.shared.open(URL(string: AppInfo.websiteHttps)!)
  }

  // MARK: - Share

  func showShareActivity(in viewController: UIViewController) {
    let text  = String(format: Localization.Share.text, AppInfo.website)
    let image = Localization.Share.image
    let items = [text, image] as [Any]

    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [.assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .openInIBooks, .print]
    viewController.present(activityViewController, animated: true, completion: nil)
  }
}
