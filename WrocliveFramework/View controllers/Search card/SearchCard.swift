// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SPAlert

private typealias Localization = Localizable.Search

public final class SearchCard: UIViewController, SearchCardViewType, CardPresentable {

  // MARK: - Properties

  public let headerView = ExtraLightVisualEffectView()
  public let titleLabel = UILabel()
  public let bookmarkButton = UIButton()
  public let searchButton = UIButton()
  public let loadingView = LoadingView()

  internal var lineSelector: LineSelector
  internal var lineTypeSelector: LineTypeSegmentedControl

  internal let viewModel: SearchCardViewModel

  // MARK: - Init

  public init(viewModel: SearchCardViewModel) {
    self.viewModel = viewModel

    // swiftlint:disable:next trailing_closure
    self.lineTypeSelector = LineTypeSegmentedControl(
      onValueChanged: { viewModel.viewDidSelectPage(page: $0) }
    )

    self.lineSelector = LineSelector(
      viewModel: self.viewModel.lineSelectorViewModel
    )

    super.init(nibName: nil, bundle: nil)
    viewModel.setView(view: self)
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ViewDidLoad

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
    self.viewModel.viewDidLoad()
  }

  // MARK: - ViewDidLayoutSubviews

  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    self.lineSelector.insetScrollViews(
      below: self.headerView,
      bottom: Constants.LineSelector.bottomInset,
      left: Constants.leftInset,
      right: Constants.rightInset
    )
  }

  // MARK: - ViewDidDisappear

  override public func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.viewModel.viewDidDisappear()
  }

  // MARK: - SearchCardViewType

  public func refresh() {
    let page = self.viewModel.page
    self.lineTypeSelector.setPage(page: page)

    let isLineSelectorVisible = self.viewModel.isLineSelectorVisible
    self.lineSelector.view.isHidden = !isLineSelectorVisible

    let isPlaceholderVisible = self.viewModel.isLoadingViewVisible
    self.loadingView.isHidden = !isPlaceholderVisible
  }

  // MARK: - Actions

  @objc
  internal func didPressSearchButton() {
    self.viewModel.viewDidPressSearchButton()
  }

  @objc
  internal func didPressBookmarkButton() {
    self.viewModel.viewDidPressBookmarkButton()
  }

  // MARK: - Alerts

  public func showBookmarkNameInputAlert() {
    // swiftlint:disable:next type_name
    typealias L = Localizable.Alert.Bookmark.NameInput

    let result = AlertCreator.showTextInput(
      title: L.title,
      message: L.message,
      placeholder: L.placeholder,
      confirm: AlertCreator.TextInputButton(title: L.save, style: .default),
      cancel: AlertCreator.TextInputButton(title: L.cancel, style: .cancel)
    )

    switch result {
    case .alert(let promise):
      _ = promise.done { [weak self] maybeName in
        guard let name = maybeName else {
          return
        }

        self?.viewModel.viewDidEnterBookmarkName(value: name)

        let savedText = Localizable.Alert.Bookmark.saved
        SPAlert.present(title: savedText, preset: .done)
      }

    case .noRootViewController:
      // This would be weird. At least 'self' should be visible.
      break
    case .alreadyShowingDifferentAlert:
      // How?
      // If we are showing different alert then it blocks bookmark button.
      // Anyway, let's ignore it. User will have to tap again.
      break
    }
  }

  public func showBookmarkNoLineSelectedAlert() {
    // swiftlint:disable:next type_name
    typealias L = Localizable.Alert.Bookmark.NoLinesSelected

    _ = AlertCreator.show(
      title: L.title,
      message: L.message,
      buttons: [
        AlertCreator.Button(title: L.ok, style: .default, result: ())
      ]
    )
  }

  public func showApiErrorAlert(error: ApiError) {
    switch error {
    case .reachabilityError:
      _ = AlertCreator.showReachabilityAlert()
    case .invalidResponse,
         .otherError:
      _ = AlertCreator.showConnectionErrorAlert()
    }
  }

  // MARK: - Close

  public func close(animated: Bool) {
    self.dismiss(animated: animated, completion: nil)
  }

  // MARK: - CardPresentable

  public var scrollView: UIScrollView? {
    let isLineSelectorVisible = !self.lineSelector.view.isHidden
    return isLineSelectorVisible ? self.lineSelector.scrollView : nil
  }
}
