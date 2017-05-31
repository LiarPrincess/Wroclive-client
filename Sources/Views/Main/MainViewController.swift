//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

//MARK: - MainViewController

class MainViewController: UIViewController {

  //MARK: - Properties

  let mapViewController = MapViewController()

  let userTrackingButton = UIButton()
  let lineSearchButton = UIButton()
  let bookmarksButton = UIButton()
  let configurationButton = UIButton()

  var lineSelectionTransitionDelegate: UIViewControllerTransitioningDelegate?
  var bookmarksTransitionDelegate: UIViewControllerTransitioningDelegate?

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  //MARK: - Actions

  @objc fileprivate func userTrackingButtonPressed() {
    logger.info("userTrackingButtonPressed")
  }

  @objc fileprivate func lineSelectionButtonPressed() {
    let relativeHeight = CGFloat(0.90)
    let controller = LineSelectionViewController()

    self.lineSelectionTransitionDelegate = CardPanelTransitionDelegate(for: controller, withRelativeHeight: relativeHeight)
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate = self.lineSelectionTransitionDelegate!

    self.present(controller, animated: true, completion: nil)
  }

  @objc fileprivate func bookmarksButtonPressed() {
    let relativeHeight = CGFloat(0.75)
    let controller = BookmarksViewController()

    self.bookmarksTransitionDelegate = CardPanelTransitionDelegate(for: controller, withRelativeHeight: relativeHeight)
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate = self.bookmarksTransitionDelegate!

    self.present(controller, animated: true, completion: nil)
  }

  @objc fileprivate func configurationButtonPressed() {
    logger.info("configurationButtonTapped")
  }

}

//MARK: - UI Init

extension MainViewController {

  fileprivate func initLayout() {
    self.initMapView()
    self.initToolbarView()
  }

  private func initMapView() {
    self.addChildViewController(self.mapViewController)
    self.view.addSubview(self.mapViewController.view)

    self.mapViewController.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.mapViewController.didMove(toParentViewController: self)
  }

  private func initToolbarView() {
    let blur = UIBlurEffect(style: .extraLight)
    let blurView = UIVisualEffectView(effect: blur)
    blurView.addBorder(at: .top)
    self.view.addSubview(blurView)

    blurView.snp.makeConstraints { make -> Void in
      make.left.right.bottom.equalToSuperview()
      make.height.equalTo(44.0)
    }

    let toolbar = UIStackView()
    toolbar.axis = .horizontal
    toolbar.alignment = .fill
    toolbar.distribution = .fillEqually
    blurView.addSubview(toolbar)

    toolbar.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    addToolbarButtons(toolbar)
  }

  private func addToolbarButtons(_ toolbar: UIStackView) {
    initToolbarButton(self.userTrackingButton)
    self.userTrackingButton.setImage(#imageLiteral(resourceName: "vecUserTracking_None"), for: .normal)
    self.userTrackingButton.addTarget(self, action: #selector(userTrackingButtonPressed), for: .touchUpInside)

    initToolbarButton(self.lineSearchButton)
    self.lineSearchButton.setImage(#imageLiteral(resourceName: "vecSearch"), for: .normal)
    self.lineSearchButton.addTarget(self, action: #selector(lineSelectionButtonPressed), for: .touchUpInside)

    initToolbarButton(self.bookmarksButton)
    self.bookmarksButton.setImage(#imageLiteral(resourceName: "vecFavorites1"), for: .normal)
    self.bookmarksButton.addTarget(self, action: #selector(bookmarksButtonPressed), for: .touchUpInside)

    initToolbarButton(self.configurationButton)
    self.configurationButton.setImage(#imageLiteral(resourceName: "vecSettings"), for: .normal)
    self.configurationButton.addTarget(self, action: #selector(configurationButtonPressed), for: .touchUpInside)

    toolbar.addArrangedSubview(self.userTrackingButton)
    toolbar.addArrangedSubview(self.lineSearchButton)
    toolbar.addArrangedSubview(self.bookmarksButton)
    toolbar.addArrangedSubview(self.configurationButton)
  }

  private func initToolbarButton(_ button: UIButton) {
    button.contentMode = .scaleAspectFit
    button.contentHorizontalAlignment = .center
    button.contentVerticalAlignment = .center
  }
}
