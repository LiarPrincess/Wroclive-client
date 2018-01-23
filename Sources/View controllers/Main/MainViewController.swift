//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import PromiseKit

private typealias Constants = MainViewControllerConstants

class MainViewController: UIViewController {

  // MARK: - Properties

  let mapViewController: MapViewController = MapViewController()

  let toolbar = UIToolbar()
  let userTrackingButton  = MKUserTrackingBarButtonItem()
  let searchButton        = UIBarButtonItem()
  let bookmarksButton     = UIBarButtonItem()
  let configurationButton = UIBarButtonItem()

  var card:                   UIViewController?
  var cardTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  // MARK: - Init

  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.startObservingColorScheme()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    self.stopObservingColorScheme()
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.requestLocationAuthorizationIfNeeded()
  }

  private func requestLocationAuthorizationIfNeeded() {
    let authorization = Managers.userLocation.authorization
    guard authorization == .notDetermined else { return }

    let delay = AppInfo.Timings.locationAuthorizationPromptDelay
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      Managers.userLocation.requestAuthorization()
    }
  }

  // MARK: - Actions

  @objc
  func searchButtonPressed() {
    let viewModel      = SearchCardViewModel()
    let viewController = SearchCard(viewModel)
    self.openCard(viewController, animated: true)
  }

  @objc
  func bookmarksButtonPressed() {
    let viewModel      = BookmarksCardViewModel()
    let viewController = BookmarksCard(viewModel)
    self.openCard(viewController, animated: true)
  }

  @objc
  func configurationButtonPressed() {
    let viewModel      = SettingsCardViewModel()
    let viewController = SettingsCard(viewModel)
    self.openCard(viewController, animated: true)
  }

  // MARK: - Open card

  private func openCard<Card: UIViewController & CardPanelPresentable>(_ card: Card, animated: Bool) {
    if let currentCard = self.card {
      currentCard.dismiss(animated: true) { [unowned self] in
        self.card = nil
        self.cardTransitionDelegate = nil
        self.openCardInner(card, animated: animated)
      }
    }
    else { self.openCardInner(card, animated: animated) }
  }

  private func openCardInner<Card: UIViewController & CardPanelPresentable>(_ card: Card, animated: Bool) {
    self.cardTransitionDelegate = CardPanelTransitionDelegate(for: card)
    card.modalPresentationStyle = .custom
    card.transitioningDelegate  = self.cardTransitionDelegate!
    self.present(card, animated: animated, completion: nil)
  }
}

// MARK: - ColorSchemeObserver

extension MainViewController: ColorSchemeObserver {

  func colorSchemeDidChange() {
    let tintColor = Managers.theme.colors.tint.value

    self.view.tintColor    = tintColor
    self.toolbar.tintColor = tintColor

    // HACK: In iOS 11 UIBarButtonItem are contained in _UIModernBarButton that prevents seting tint color.
    // Previously: button.customView?.tintColor = color
    self.forEachRecurrentSubview(of: self.toolbar) { $0.tintColor = tintColor }
  }

  private func forEachRecurrentSubview(of view: UIView, do block: (UIView) -> ()) {
    for subview in view.subviews {
      block(subview)
      forEachRecurrentSubview(of: subview, do: block)
    }
  }
}
