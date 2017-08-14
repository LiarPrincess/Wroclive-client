//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {

  // MARK: - Properties

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.tintColor = Theme.current.colorScheme.tint
    self.view.backgroundColor = UIColor.lightGray

    let navigationBar = UINavigationBar()
    navigationBar.delegate = self

    // https://stackoverflow.com/a/21548900
    self.view.addSubview(navigationBar)
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(self.topLayoutGuide.snp.bottom)
      make.left.right.equalToSuperview()
    }

    let imageSize = CGSize(width: 22.0, height: 22.0)
    let closeImage = StyleKit.drawCloseImage(size: imageSize, renderingMode: .alwaysTemplate)

    let navigationItem = UINavigationItem()
    let closeNavigationItem = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(closeButtonPressed))
    navigationItem.rightBarButtonItem = closeNavigationItem
    navigationBar.setItems([navigationItem], animated: false)
  }

  @objc func closeButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }
}

extension ConfigurationViewController: UINavigationBarDelegate {
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}
