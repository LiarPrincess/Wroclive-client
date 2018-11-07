// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class SettingsCardCoordinator: CardCoordinator {

  var card:                   SettingsCard?
  var cardTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  let parent: UIViewController

  init(_ parent: UIViewController) {
    self.parent = parent
  }

  func start() {
    let viewModel = SettingsCardViewModel()
    self.card     = SettingsCard(viewModel)

    viewModel.showRateControl
      .drive(onNext: { [unowned self] in self.rateApp() })
      .disposed(by: viewModel.disposeBag)

    viewModel.showShareControl
      .drive(onNext: { [unowned self] in self.showShareActivity() })
      .disposed(by: viewModel.disposeBag)

    viewModel.showAboutPage
      .drive(onNext: { [unowned self] in self.showAboutPage() })
      .disposed(by: viewModel.disposeBag)

    self.presentCard(animated: true)
  }

  func rateApp() {
    UIApplication.shared.open(AppEnvironment.variables.appStore.writeReviewUrl)
  }

  func showShareActivity() {
    guard let card = self.card
      else { fatalError("SettingsCardCoordinator has to be started first") }

    let url   = AppEnvironment.variables.appStore.shareUrl
    let text  = Localizable.Share.message(url.absoluteString)
    let image = Assets.shareImage.image
    let items = [text, image] as [Any]

    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.excludedActivityTypes  = [.assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .openInIBooks, .print]
    activityViewController.modalPresentationStyle = .overCurrentContext
    card.present(activityViewController, animated: true, completion: nil)
  }

  func showAboutPage() {
    guard let card = self.card
      else { fatalError("SettingsCardCoordinator has to be started first") }

    let safariViewController = SFSafariViewController(url: AppEnvironment.variables.websiteUrl)
    safariViewController.modalPresentationStyle = .overFullScreen
    card.present(safariViewController, animated: true, completion: nil)
  }
}
