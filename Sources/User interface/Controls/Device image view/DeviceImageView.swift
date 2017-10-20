//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

class DeviceImageView: UIView {

  // MARK: - Properties

  private let deviceBorder  = UIImageView()
  let contentView           = UIView()

  // MARK: - Init

  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.deviceBorder.image       = #imageLiteral(resourceName: "Image_DeviceBorder")
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
