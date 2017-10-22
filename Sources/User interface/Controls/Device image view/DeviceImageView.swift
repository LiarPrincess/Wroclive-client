//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

class DeviceImageView: UIView {

  // MARK: - Properties

  private let deviceBorder = UIImageView()
  private let contentView: UIView

  // MARK: - Init

  convenience init(content contentView: UIView) {
    self.init(frame: .zero, content: contentView)
  }

  init(frame: CGRect, content contentView: UIView) {
    self.contentView = contentView
    super.init(frame: frame)

    self.deviceBorder.image       = Images.deviceBorder
    self.deviceBorder.contentMode = .scaleAspectFit

    self.addSubview(self.deviceBorder)
    self.deviceBorder.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.contentView.layer.borderColor = Managers.theme.colors.backgroundAccent.cgColor
    self.contentView.layer.borderWidth = 1.0 / Managers.device.screenScale

    self.deviceBorder.addSubview(self.contentView)
    self.contentView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.73)
      make.width.equalTo(self.snp.height).multipliedBy(0.42)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
