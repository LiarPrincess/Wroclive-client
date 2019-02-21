// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import RxSwift
import RxCocoa

private typealias Constants = MainViewControllerConstants

public final class MainViewController: UIViewController {

  // MARK: - Properties

  public let mapViewController: MapViewController

  public lazy var toolbar: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  public let userTrackingButton  = MKUserTrackingBarButtonItem()
  public let searchButton        = UIButton(type: .custom)
  public let bookmarksButton     = UIButton(type: .custom)
  public let configurationButton = UIButton(type: .custom)

  private let viewModel: MainViewModel
  private let disposeBag = DisposeBag()

  // MARK: - Init

  public init(_ viewModel: MainViewModel) {
    self.viewModel = viewModel
    self.mapViewController = MapViewController(viewModel.mapViewModel)
    super.init(nibName: nil, bundle: nil)
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
    self.addMapViewSafeAreaInsetsSoLegalInfoIsVisible()
  }

  private func addMapViewSafeAreaInsetsSoLegalInfoIsVisible() {
    let toolbarHeight = self.toolbar.bounds.height
    let currentInset  = self.mapViewController.additionalSafeAreaInsets.bottom

    if currentInset < toolbarHeight {
      self.mapViewController.additionalSafeAreaInsets.bottom = toolbarHeight
    }
  }

  // MARK: - Actions

  @objc
  public func searchButtonPressed() {
    self.viewModel.didPressSearchButton.onNext()
  }

  @objc
  public func bookmarksButtonPressed() {
    self.viewModel.didPressBookmarkButton.onNext()
  }

  @objc
  public func configurationButtonPressed() {
    self.viewModel.didPressSettingsButton.onNext()
  }
}
