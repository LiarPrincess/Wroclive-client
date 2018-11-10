// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import RxSwift
import RxCocoa

private typealias Constants = MainViewControllerConstants

class MainViewController: UIViewController {

  // MARK: - Properties

  let mapViewController = MapViewController()

  let toolbar = UIToolbar()
  let userTrackingButton  = MKUserTrackingBarButtonItem()
  let searchButton        = UIBarButtonItem()
  let bookmarksButton     = UIBarButtonItem()
  let configurationButton = UIBarButtonItem()

  private let viewModel: MainViewModel
  private let disposeBag = DisposeBag()

  // MARK: - Init

  init(_ viewModel: MainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.addMapViewSafeAreaInsetsSoLegalInfoIsVisible()
  }

  private func addMapViewSafeAreaInsetsSoLegalInfoIsVisible() {
    let toolbarHeight = self.toolbar.bounds.height
    let currentInset  = self.mapViewController.additionalSafeAreaInsets.bottom

    if currentInset < toolbarHeight {
      self.mapViewController.additionalSafeAreaInsets.bottom = toolbarHeight
    }
  }

  // MARK: - Actions (for some reason UIBarButtonItem.rx.tap fails, so we can't bind)

  @objc
  func searchButtonPressed() {
    self.viewModel.didPressSearchButton.onNext()
  }

  @objc
  func bookmarksButtonPressed() {
    self.viewModel.didPressBookmarkButton.onNext()
  }

  @objc
  func configurationButtonPressed() {
    self.viewModel.didPressSettingsButton.onNext()
  }
}
