// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Constants = SearchCardConstants
private typealias Localization = Localizable.Search

public final class SearchCard:
  UIViewController, SearchCardViewType, CustomCardPanelPresentable
{

  // MARK: - Properties

  public var headerView: UIVisualEffectView = {
    let headerViewBlur = UIBlurEffect(style: Theme.colors.blurStyle)
    return UIVisualEffectView(effect: headerViewBlur)
  }()

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

    self.lineTypeSelector = LineTypeSegmentedControl(
      onPageSelected: { viewModel.viewDidSelectPage(page: $0) }
    )

    self.lineSelector = LineSelector(
      viewModel: self.viewModel.lineSelectorViewModel
    )

    super.init(nibName: nil, bundle: nil)
    viewModel.setView(view: self)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetLineSelectorBelowHeaderView()
  }

  private func insetLineSelectorBelowHeaderView() {
    let currentInset = self.lineSelector.contentInset
    let headerHeight = self.headerView.bounds.height

    if currentInset.top < headerHeight {
      let topInset    = headerHeight
      let leftInset   = Constants.leftInset
      let rightInset  = Constants.rightInset
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

  // MARK: -  Subview visibility

  public func setIsLineSelectorVisible(value: Bool) {
    let isHidden = !value
    self.lineSelector.view.isHidden = isHidden
  }

  public func setIsPlaceholderVisible(value: Bool) {
    let isHidden = !value
    self.placeholderView.isHidden = isHidden
  }

  // MARK: - Page

  public func setPage(page: LineType) {
    self.lineTypeSelector.setPage(page: page)
  }

  // MARK: - Search

  @objc
  internal func didPressSearchButton() {
    self.viewModel.didPressSearchButton()
  }

  // MARK: - Bookmark

  @objc
  internal func didPressBookmarkButton() {
    self.viewModel.didPressBookmarkButton()
  }

  public func showBookmarkNameInputAlert() {
    _ = BookmarkAlerts.showNameInputAlert()
      .done { [weak self] nameOrNone in
        guard let name = nameOrNone else {
          return
        }

        self?.viewModel.didEnterBookmarkName(value: name)
      }
  }

  public func showBookmarkNoLineSelectedAlert() {
    _ = BookmarkAlerts.showNoLinesSelectedAlert()
  }

  // MARK: - Api alert

  public func showApiErrorAlert(error: ApiError) {
    switch error {
    case .reachabilityError:
      _ = NetworkAlerts.showNoInternetAlert()
    case .invalidResponse,
         .otherError:
      _ = NetworkAlerts.showConnectionErrorAlert()
    }
  }

  // MARK: - Close

  public func close(animated: Bool) {
    self.dismiss(animated: animated, completion: nil)
  }

  // MARK: - CustomCardPanelPresentable

  public var scrollView: UIScrollView? {
    return self.lineSelector.scrollView
  }
}
