//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Localization = Localizable.App

class AppManagerImpl: AppManager {

  // MARK: - Info

  var name:    String { return self.bundleInformation(key: kCFBundleExecutableKey as String) ?? "Kek" }
  var version: String { return self.bundleInformation(key: "CFBundleShortVersionString")     ?? "1.0" }
  var bundle:  String { return self.bundleInformation(key: kCFBundleIdentifierKey as String) ?? "com.kekapp.kek" }

  var website:      String { return "www.kekapp.pl"  }
  var websiteHttps: String { return "https://\(self.website)" }
  var mail:         String { return "mail@kekapp.pl" }

  private func bundleInformation(key: String) -> String? {
    return Bundle.main.infoDictionary?[key] as? String
  }

  // MARK: - Tutorial

  var hasSeenTutorialPresentation: Bool { // -> user defaults
    get { return true }
    set { }
  }

  // MARK: - Website

  func openWebsite() {
    UIApplication.shared.open(URL(string: self.websiteHttps)!)
  }

  // MARK: - Share

  func showShareActivity(in viewController: UIViewController) {
    let text  = String(format: Localization.Share.text, self.website)
    let image = Localization.Share.image
    let items = [text, image] as [Any]

    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [.assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .openInIBooks, .print]
    viewController.present(activityViewController, animated: true, completion: nil)
  }
}
