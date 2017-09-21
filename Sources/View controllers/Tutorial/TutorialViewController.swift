//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = TutorialViewControllerConstants.Layout
private typealias Localization = Localizable.Presentation.Tutorial

enum TutorialViewControllerMode {
  case firstUse
  case `default`
}

class TutorialViewController: UIViewController {

  // MARK: - Properties

  let mode: TutorialViewControllerMode

  let presentation = TutorialPresentation()
  let closeButton  = UIButton(type: .system)
  let closeFirstUseButton = UIButton(type: .system)

  // MARK: - Init

  init(mode: TutorialViewControllerMode) {
    self.mode = mode
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.addChildViewController(self.presentation)
    self.view.addSubview(self.presentation.view)

    self.presentation.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.presentation.didMove(toParentViewController: self)

    switch self.mode {
    case .default:   self.initBackButton()
    case .firstUse: self.initSkipButton()
    }
  }

  // MARK: - Back button

  private func initBackButton() {
    let image = StyleKit.drawBackTemplateImage(size: Layout.BackButton.imageSize)

    self.closeButton.setImage(image, for: .normal)
    self.closeButton.addTarget(self, action: #selector(TutorialViewController.closeButtonPressed), for: .touchUpInside)
    self.closeButton.contentEdgeInsets = Layout.BackButton.insets

    self.view.addSubview(self.closeButton)
    self.closeButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
    }
  }

  private func initSkipButton() {
    let titleAttributes = Managers.theme.textAttributes(for: .body, alignment: .left, color: .tint)
    let title = NSAttributedString(string: Localization.skip, attributes: titleAttributes)

    self.closeFirstUseButton.setAttributedTitle(title, for: .normal)
    self.closeFirstUseButton.addTarget(self, action: #selector(TutorialViewController.closeButtonPressed), for: .touchUpInside)
    self.closeFirstUseButton.contentEdgeInsets = Layout.SkipButton.insets

    self.view.addSubview(self.closeFirstUseButton)
    self.closeFirstUseButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.right.equalToSuperview()
    }
  }

  // MARK: - Actions

  @objc func closeButtonPressed() {
    if self.mode == .firstUse {
      Managers.app.hasSeenTutorial = true

      let controller = MainViewController()
      controller.modalTransitionStyle = .flipHorizontal
      self.present(controller, animated: true, completion: nil)
    }
    else {
      self.dismiss(animated: true, completion: nil)
    }
  }
}
