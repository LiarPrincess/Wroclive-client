//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import PromiseKit
import RxSwift

private typealias Constants = MainViewControllerConstants

class MainViewController: UIViewController {

  // MARK: - Properties

  let mapViewController = MapViewController()

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

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
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

    viewModel.selectedBookmark
      .drive(onNext: { [weak viewController] bookmark in
        AppEnvironment.live.startTracking(bookmark.lines)
        viewController?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: viewModel.disposeBag)
  }

  @objc
  func configurationButtonPressed() {
    let viewModel      = SettingsCardViewModel()
    let viewController = SettingsCard(viewModel)
    self.openCard(viewController, animated: true)
  }

  // MARK: - Open card

  private func openCard(_ cardPanel: CardPanel, animated: Bool) {
    if let currentCard = self.card {
      currentCard.dismiss(animated: true) { [unowned self] in
        self.card = nil
        self.cardTransitionDelegate = nil
        self.openCardInner(cardPanel, animated: animated)
      }
    }
    else { self.openCardInner(cardPanel, animated: animated) }
  }

  private func openCardInner(_ cardPanel: CardPanel, animated: Bool) {
    self.cardTransitionDelegate = CardPanelTransitionDelegate(for: cardPanel)
    cardPanel.modalPresentationStyle = .custom
    cardPanel.transitioningDelegate  = self.cardTransitionDelegate!
    self.present(cardPanel, animated: animated, completion: nil)
  }
}
