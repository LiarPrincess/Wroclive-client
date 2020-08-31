// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Localization = Localizable.Search

public final class SearchCard: UIViewController, SearchCardViewType, CardPanelPresentable {

  // MARK: - Properties

  public let headerView = ExtraLightVisualEffectView()
  public let titleLabel = UILabel()
  public let bookmarkButton = UIButton()
  public let searchButton = UIButton()
  public let placeholderView = SearchPlaceholderView()

  internal var lineSelector: LineSelector
  internal var lineTypeSelector: LineTypeSegmentedControl

  internal let viewModel: SearchCardViewModel
  internal let environment: Environment

  // MARK: - Init

  public init(viewModel: SearchCardViewModel, environment: Environment) {
    self.viewModel = viewModel
    self.environment = environment

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

  // swiftlint:disable:next unavailable_function
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ViewDidLoad

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  // MARK: - ViewDidLayoutSubviews

  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetLineSelectorBelowHeaderView()
  }

  private func insetLineSelectorBelowHeaderView() {
    let currentInset = self.lineSelector.contentInset
    let headerHeight = self.headerView.bounds.height

    if currentInset.top < headerHeight {
      let topInset = headerHeight
      let leftInset = Constants.leftInset
      let rightInset = Constants.rightInset
      let bottomInset = Constants.LineSelector.bottomInset

      self.lineSelector.contentInset = UIEdgeInsets(top: topInset,
                                                    left: leftInset,
                                                    bottom: bottomInset,
                                                    right: rightInset)
      self.lineSelector.scrollIndicatorInsets = UIEdgeInsets(top: topInset,
                                                             left: 0.0,
                                                             bottom: 0.0,
                                                             right: 0.0)
    }
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

    let isPlaceholderVisible = self.viewModel.isPlaceholderVisible
    self.placeholderView.isHidden = !isPlaceholderVisible
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
    // swiftlint:disable:next nesting type_name
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
      }

    case .alreadyShowingDifferentAlert:
      // How?
      // If we are showing different alert then it blocks bookmark button.
      // Anyway, let's ignore it. User will have to tap again.
      break
    }
  }

  public func showBookmarkNoLineSelectedAlert() {
    // swiftlint:disable:next nesting type_name
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

  // MARK: - CustomCardPanelPresentable

  public var scrollView: UIScrollView? {
    let isLineSelectorVisible = !self.lineSelector.view.isHidden
    return isLineSelectorVisible ? self.lineSelector.scrollView : nil
  }
}
