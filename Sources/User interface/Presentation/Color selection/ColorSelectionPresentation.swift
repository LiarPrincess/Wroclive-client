//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Constants = ColorSelectionPresentationConstants

class ColorSelectionPresentation: UIViewController, ColorSchemeObserver {

  // MARK: - Properties

  private let gradientLayer = CAGradientLayer()

  private lazy var colorSchemeTestView = ColorSchemeTestView()
  private lazy var deviceImageView     = DeviceImageView(content: self.colorSchemeTestView)

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

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.gradientLayer.frame = self.view.layer.bounds
  }

  // MARK: - Init layout

  private func initLayout() {
    self.gradientLayer.frame     = self.view.layer.bounds
    self.gradientLayer.colors    = Managers.theme.colors.presentation.gradient.map { $0.cgColor }
    self.gradientLayer.locations = Managers.theme.colors.presentation.gradientLocations.map { NSNumber(value: $0) }
    self.view.layer.addSublayer(self.gradientLayer)

    self.view.addSubview(self.deviceImageView)
    self.deviceImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.topOffset)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview().offset(-Constants.bottomOffset)
    }
  }

  // MARK: - ColorSchemeObserver

  func colorSchemeDidChange() {
    self.colorSchemeTestView.setCurrentColorScheme()
  }
}
