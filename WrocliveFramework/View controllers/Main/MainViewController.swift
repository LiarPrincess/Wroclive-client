// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit

public final class MainViewController: UIViewController {

  // MARK: - Properties

  public let mapViewController: MapViewController

  public let toolbar = ExtraLightVisualEffectView()
  public let toolbarStackView = UIStackView()

  public let userTrackingButton = MKUserTrackingBarButtonItem()
  public let searchButton = UIButton(type: .custom)
  public let bookmarksButton = UIButton(type: .custom)
  public let configurationButton = UIButton(type: .custom)

  internal let viewModel: MainViewModel

  // MARK: - Init

  public init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    self.mapViewController = MapViewController(viewModel: viewModel.mapViewModel)
    super.init(nibName: nil, bundle: nil)
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
    self.updateMapViewSafeAreaInsetsSoLegalInfoIsVisible()
  }

  private func updateMapViewSafeAreaInsetsSoLegalInfoIsVisible() {
    let toolbarHeight = self.toolbarStackView.bounds.height
    let currentInset = self.mapViewController.additionalSafeAreaInsets.bottom

    if currentInset < toolbarHeight {
      self.mapViewController.additionalSafeAreaInsets.bottom = toolbarHeight
    }
  }

  // MARK: - Actions

  @objc
  public func searchButtonPressed() {
    self.viewModel.didPressSearchButton()
  }

  @objc
  public func bookmarksButtonPressed() {
    self.viewModel.didPressBookmarkButton()
  }

  @objc
  public func settingsButtonPressed() {
    self.viewModel.didPressSettingsButton()
  }
}
