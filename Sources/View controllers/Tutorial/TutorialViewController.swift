//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = TutorialViewControllerConstants.Layout
private typealias Localization = Localizable.Presentation.Tutorial

enum TutorialViewControllerCloseMode {
  case back
  case skip
}

class TutorialViewController: UIViewController {

  // MARK: - Properties

  let closeMode: TutorialViewControllerCloseMode

  let presentation = TutorialPresentation()
  let backButton   = UIButton(type: .system)
  let skipButton   = UIButton(type: .system)

  // MARK: - Init

  init(closeMode: TutorialViewControllerCloseMode) {
    self.closeMode = closeMode
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

    switch self.closeMode {
    case .back: self.initBackButton()
    case .skip: self.initSkipButton()
    }
  }

  // MARK: - Back button

  private func initBackButton() {
    let image = StyleKit.drawBackTemplateImage(size: Layout.BackButton.imageSize)

    self.backButton.setImage(image, for: .normal)
    self.backButton.addTarget(self, action: #selector(TutorialViewController.closeButtonPressed), for: .touchUpInside)
    self.backButton.contentEdgeInsets = Layout.BackButton.insets

    self.view.addSubview(self.backButton)
    self.backButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
    }
  }

  private func initSkipButton() {
    let titleAttributes = Managers.theme.textAttributes(for: .body, alignment: .left, color: .tint)
    let title = NSAttributedString(string: Localization.skip, attributes: titleAttributes)

    self.skipButton.setAttributedTitle(title, for: .normal)
    self.skipButton.addTarget(self, action: #selector(TutorialViewController.closeButtonPressed), for: .touchUpInside)
    self.skipButton.contentEdgeInsets = Layout.SkipButton.insets

    self.view.addSubview(self.skipButton)
    self.skipButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.right.equalToSuperview()
    }
  }

  // MARK: - Actions

  @objc func closeButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }
}
