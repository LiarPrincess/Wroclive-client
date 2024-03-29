// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit

public final class MainViewController: UIViewController {

  // MARK: - Properties

  public let map: MapViewController

  public let toolbar = ExtraLightVisualEffectView()
  public let toolbarStackView = UIStackView()

  public let userTrackingButton = MKUserTrackingBarButtonItem()
  public let searchButton = UIButton(type: .custom)
  public let bookmarksButton = UIButton(type: .custom)
  public let notificationsButton = UIButton(type: .custom)
  public let configurationButton = UIButton(type: .custom)

  internal let viewModel: MainViewModel

  // MARK: - Init

  public init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    self.map = MapViewController(viewModel: viewModel.mapViewModel)
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
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
    let currentInset = self.map.additionalSafeAreaInsets.bottom

    if currentInset < toolbarHeight {
      self.map.additionalSafeAreaInsets.bottom = toolbarHeight
    }
  }

  // MARK: - Actions

  @objc
  public func searchButtonPressed() {
    self.viewModel.didPressSearchButton()
  }

  @objc
  public func bookmarksButtonPressed() {
    self.viewModel.didPressBookmarksButton()
  }

  @objc
  public func notificationsButtonPressed() {
    self.viewModel.didPressNotificationsButton()
  }

  @objc
  public func settingsButtonPressed() {
    self.viewModel.didPressSettingsButton()
  }
}
