// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import PromiseKit
import SafariServices

// swiftlint:disable weak_delegate

public final class SettingsCardCoordinator: CardCoordinator, SettingsCardViewModelDelegate {

  public var card: SettingsCard?
  public let parent: UIViewController
  public var cardTransitionDelegate: UIViewControllerTransitioningDelegate?

  public let store: Store<AppState>
  public let environment: Environment

  public init(parent: UIViewController,
              store: Store<AppState>,
              environment: Environment) {
    self.parent = parent
    self.store = store
    self.environment = environment
  }

  public func start() -> Guarantee<Void> {
    let viewModel = SettingsCardViewModel(store: self.store, delegate: self)
    let card = SettingsCard(viewModel: viewModel, environment: self.environment)

    let height = min(
      0.75 * self.environment.device.screenBounds.height,
      CGFloat(500.0)
    )

    self.card = card
    return self.present(card: card, withHeight: height, animated: true)
  }

  public func rateApp() {
    let url = self.environment.configuration.appStore.writeReviewUrl
    UIApplication.shared.open(url)
  }

  public func showShareActivity() {
    guard let card = self.card else {
      fatalError("SettingsCardCoordinator has to be started first")
    }

    let url = self.environment.configuration.appStore.shareUrl
    let text = Localizable.Share.message(url.absoluteString)
    let image = ImageAsset.shareImage.value
    let items = [text, image] as [Any]

    let activityViewController = UIActivityViewController(
      activityItems: items,
      applicationActivities: nil
    )

    activityViewController.excludedActivityTypes = [
      .assignToContact,
      .saveToCameraRoll,
      .addToReadingList,
      .postToFlickr,
      .postToVimeo,
      .openInIBooks,
      .print
    ]

    activityViewController.modalPresentationStyle = .overCurrentContext
    card.present(activityViewController, animated: true, completion: nil)
  }

  public func showAboutPage() {
    guard let card = self.card else {
      fatalError("SettingsCardCoordinator has to be started first")
    }

    let url = self.environment.configuration.websiteUrl
    let safariViewController = SFSafariViewController(url: url)
    safariViewController.modalPresentationStyle = .overFullScreen
    card.present(safariViewController, animated: true, completion: nil)
  }
}
