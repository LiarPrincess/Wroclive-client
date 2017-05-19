//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import SnapKit

// reusable cell identifier (register.*cell)
// collection.registerClass(ThumbnailCell.self, forCellWithReuseIdentifier: ThumbnailIdentifier)

// DynamicFontHelper.defaultHelper.DeviceFont

class MainViewController: UIViewController {

  //MARK: - Properties

  let mapViewController = MapViewController()

  let userTrackingButton = UIButton()
  let lineSearchButton = UIButton()
  let bookmarksButton = UIButton()
  let configurationButton = UIButton()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.initMapViewController()
    self.initToolbar()
  }

  //MARK: - Actions

  @objc fileprivate func userTrackingButtonTapped() {
    log.info("userTrackingButtonTapped")
  }

  @objc fileprivate func lineSearchButtonTapped() {
    log.info("lineSearchButtonTapped")
  }

  @objc fileprivate func bookmarksButtonTapped() {
    log.info("bookmarksButtonTapped")
  }

  @objc fileprivate func configurationButtonTapped() {
    log.info("configurationButtonTapped")
  }

}

//MARK: - UI Init

extension MainViewController {

  fileprivate func initMapViewController() {
    addChildViewController(mapViewController)
    view.addSubview(mapViewController.view)

    mapViewController.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    mapViewController.didMove(toParentViewController: self)
  }

  fileprivate func initToolbar() {
    let blur = UIBlurEffect(style: .extraLight)
    let blurView = UIVisualEffectView(effect: blur)
    view.addSubview(blurView)

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
    func applyCommmonSettings(_ button: UIButton) {
      button.contentMode = .scaleAspectFit
      button.contentHorizontalAlignment = .center
      button.contentVerticalAlignment = .center
    }

    applyCommmonSettings(userTrackingButton)
    userTrackingButton.setImage(#imageLiteral(resourceName: "vecUserTracking_None"), for: .normal)
    userTrackingButton.addTarget(self, action: #selector(userTrackingButtonTapped), for: .touchUpInside)

    applyCommmonSettings(lineSearchButton)
    lineSearchButton.setImage(#imageLiteral(resourceName: "vecSearch"), for: .normal)
    lineSearchButton.addTarget(self, action: #selector(lineSearchButtonTapped), for: .touchUpInside)

    applyCommmonSettings(bookmarksButton)
    bookmarksButton.setImage(#imageLiteral(resourceName: "vecFavorites1"), for: .normal)
    bookmarksButton.addTarget(self, action: #selector(bookmarksButtonTapped), for: .touchUpInside)

    applyCommmonSettings(configurationButton)
    configurationButton.setImage(#imageLiteral(resourceName: "vecSettings"), for: .normal)
    configurationButton.addTarget(self, action: #selector(configurationButtonTapped), for: .touchUpInside)

    toolbar.addArrangedSubview(userTrackingButton)
    toolbar.addArrangedSubview(lineSearchButton)
    toolbar.addArrangedSubview(bookmarksButton)
    toolbar.addArrangedSubview(configurationButton)
  }
}
