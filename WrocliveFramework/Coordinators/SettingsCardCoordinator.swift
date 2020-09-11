// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import os.log
import UIKit
import MessageUI
import ReSwift
import PromiseKit
import SafariServices

// swiftlint:disable weak_delegate

public final class SettingsCardCoordinator: NSObject,
  CardCoordinator, SettingsCardViewModelDelegate,
  MFMailComposeViewControllerDelegate {

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
      0.8 * self.environment.device.screenBounds.height,
      CGFloat(600.0)
    )

    self.card = card
    return self.present(card: card, withHeight: height, animated: true)
  }

  // MARK: - Rate

  public func rateApp() {
    let url = self.environment.configuration.appStore.writeReview
    UIApplication.shared.open(url)
  }

  // MARK: - Share

  public func showShareActivity() {
    guard let card = self.card else {
      fatalError("SettingsCardCoordinator has to be started first")
    }

    let url = self.environment.configuration.appStore.url
    let text = Localizable.Share.message(url.absoluteString)
    let image = ImageAsset.share.value
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

  // MARK: - Privacy policy

  public func showPrivacyPolicy() {
    let url = self.environment.configuration.privacyPolicyUrl
    self.openSafari(url: url)
  }

  // MARK: - Report error

  public func reportError() {
    let bundle = self.environment.bundle
    let device = self.environment.device
    let appName = bundle.name

    let recipient = self.environment.configuration.reportErrorRecipient
    let subject = "\(appName): Zgłoszenie błędu/Error report"
    let body = """


\(appName) \(bundle.version)
\(device.model), \(device.systemName) \(device.systemVersion)
"""

    self.sendMail(recipient: recipient, subject: subject, body: body)
  }

  // MARK: - Show code

  public func showCode() {
    let url = self.environment.configuration.githubUrl
    self.openSafari(url: url)
  }

  // MARK: - Helper - open Safari

  private func openSafari(url: URL) {
    guard let card = self.card else {
      fatalError("SettingsCardCoordinator has to be started first")
    }

    let safari = SFSafariViewController(url: url)
    safari.preferredControlTintColor = ColorScheme.tint
    safari.modalPresentationStyle = .overFullScreen
    card.present(safari, animated: true, completion: nil)
  }

  // MARK: - Helper - send mail

  // Source: https://stackoverflow.com/a/55765362
  private func sendMail(recipient: String,
                        subject: String,
                        body: String) {
    guard let card = self.card else {
      fatalError("SettingsCardCoordinator has to be started first")
    }

    if MFMailComposeViewController.canSendMail() {
      let mail = MFMailComposeViewController()
      mail.setToRecipients([recipient])
      mail.setSubject(subject)
      mail.setMessageBody(body, isHTML: false)
      mail.mailComposeDelegate = self
      mail.navigationBar.tintColor = ColorScheme.tint
      card.present(mail, animated: true, completion: nil)
      return
    }

    if let url = self.createThirdPartyMailUrl(to: recipient,
                                              subject: subject,
                                              body: body) {
      UIApplication.shared.open(url)
      return
    }

    let log = self.environment.log.app
    os_log("Unable to send error report mail", log: log, type: .info)
  }

  public func mailComposeController(_ controller: MFMailComposeViewController,
                                    didFinishWith result: MFMailComposeResult,
                                    error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }

  private func createThirdPartyMailUrl(to: String,
                                       subject: String,
                                       body: String) -> URL? {
    let allowed = CharacterSet.urlHostAllowed

    guard let subject = subject.addingPercentEncoding(withAllowedCharacters: allowed),
          let body = body.addingPercentEncoding(withAllowedCharacters: allowed) else {
      return nil
    }

    let thirdPartyStrings = [
      "googlegmail://co?to=\(to)&subject=\(subject)&body=\(body)",
      "ms-outlook://compose?to=\(to)&subject=\(subject)",
      "ymail://mail/compose?to=\(to)&subject=\(subject)&body=\(body)",
      "readdle-spark://compose?recipient=\(to)&subject=\(subject)&body=\(body)",
      "mailto:\(to)?subject=\(subject)&body=\(body)"
    ]

    for string in thirdPartyStrings {
      if let url = URL(string: string), UIApplication.shared.canOpenURL(url) {
        return url
      }
    }

    return nil
  }
}
