//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SafariServices

enum SearchCardOperations {

  static func rateApp() {
    let url = URL(string: AppInfo.AppStore.writeReviewUrl)!
    UIApplication.shared.open(url)
  }

  static func showShareActivity(in viewController: UIViewController) {
    let text  = String(format: Localizable.Share.message, AppInfo.AppStore.shareUrl)
    let image = Assets.shareImage
    let items = [text, image] as [Any]

    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.excludedActivityTypes  = [.assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .openInIBooks, .print]
    activityViewController.modalPresentationStyle = .overCurrentContext
    viewController.present(activityViewController, animated: true, completion: nil)
  }

  static func showAboutPage(in viewController: UIViewController) {
    let url = URL(string: AppInfo.Website.about)!

    let safariViewController = SFSafariViewController(url: url)
    safariViewController.modalPresentationStyle = .overFullScreen
    viewController.present(safariViewController, animated: true, completion: nil)
  }
}
