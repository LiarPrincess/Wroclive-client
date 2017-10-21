//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class AppManagerImpl: AppManager {

  func openWebsite() {
    let url = URL(string: AppInfo.websiteHttps)!
    UIApplication.shared.open(url)
  }

  func showShareActivity(in viewController: UIViewController) {
    let text  = String(format: Localizable.Share.text, AppInfo.website)
    let image = Images.share
    let items = [text, image] as [Any]

    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [.assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .openInIBooks, .print]
    viewController.present(activityViewController, animated: true, completion: nil)
  }
}