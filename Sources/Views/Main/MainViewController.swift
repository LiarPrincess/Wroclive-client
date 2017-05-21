//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import SnapKit

// DynamicFontHelper.defaultHelper.DeviceFont

class MainViewController: UIViewController {

  //MARK: - Properties

  let mapViewController = MapViewController()

  let userTrackingButton = UIButton()
  let lineSearchButton = UIButton()
  let bookmarksButton = UIButton()
  let configurationButton = UIButton()

  var bookmarksTransitionDelegate: UIViewControllerTransitioningDelegate?

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.initMapView()
    self.initToolbarView()
  }

  //MARK: - Actions

  @objc fileprivate func userTrackingButtonPressed() {
    log.info("userTrackingButtonTapped")
  }

  @objc fileprivate func lineSearchButtonPressed() {
    log.info("lineSearchButtonTapped")
  }

  @objc fileprivate func bookmarksButtonPressed() {
    let relativeHeight = CGFloat(0.75)
    let modalViewController = BookmarksViewController()

    self.bookmarksTransitionDelegate = CardPanelTransitionDelegate(for: modalViewController, withRelativeHeight: relativeHeight)
    modalViewController.modalPresentationStyle = .custom
    modalViewController.transitioningDelegate = self.bookmarksTransitionDelegate!

    self.present(modalViewController, animated: true, completion: nil)
  }

  @objc fileprivate func configurationButtonPressed() {
    log.info("configurationButtonTapped")
  }

}

//MARK: - UI Init

extension MainViewController {

  fileprivate func initMapView() {
    self.addChildViewController(self.mapViewController)
    self.view.addSubview(self.mapViewController.view)

    self.mapViewController.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.mapViewController.didMove(toParentViewController: self)
  }

  fileprivate func initToolbarView() {
    let blur = UIBlurEffect(style: .extraLight)
    let blurView = UIVisualEffectView(effect: blur)
    self.view.addSubview(blurView)

    blurView.snp.makeConstraints { make -> Void in
      make.left.right.bottom.equalToSuperview()
      make.height.equalTo(44.0)
    }

    let topBorder = UIView()
    topBorder.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
    blurView.addSubview(topBorder)

    topBorder.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview()
      make.height.equalTo(0.5)
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
    applyToolbarButtonSettings(self.userTrackingButton)
    self.userTrackingButton.setImage(#imageLiteral(resourceName: "vecUserTracking_None"), for: .normal)
    self.userTrackingButton.addTarget(self, action: #selector(userTrackingButtonPressed), for: .touchUpInside)

    applyToolbarButtonSettings(self.lineSearchButton)
    self.lineSearchButton.setImage(#imageLiteral(resourceName: "vecSearch"), for: .normal)
    self.lineSearchButton.addTarget(self, action: #selector(lineSearchButtonPressed), for: .touchUpInside)

    applyToolbarButtonSettings(self.bookmarksButton)
    self.bookmarksButton.setImage(#imageLiteral(resourceName: "vecFavorites1"), for: .normal)
    self.bookmarksButton.addTarget(self, action: #selector(bookmarksButtonPressed), for: .touchUpInside)

    applyToolbarButtonSettings(self.configurationButton)
    self.configurationButton.setImage(#imageLiteral(resourceName: "vecSettings"), for: .normal)
    self.configurationButton.addTarget(self, action: #selector(configurationButtonPressed), for: .touchUpInside)

    toolbar.addArrangedSubview(self.userTrackingButton)
    toolbar.addArrangedSubview(self.lineSearchButton)
    toolbar.addArrangedSubview(self.bookmarksButton)
    toolbar.addArrangedSubview(self.configurationButton)
  }

  private func applyToolbarButtonSettings(_ button: UIButton) {
    button.contentMode = .scaleAspectFit
    button.contentHorizontalAlignment = .center
    button.contentVerticalAlignment = .center
  }
}
