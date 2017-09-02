//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Constants    = ConfigurationViewControllerConstants
private typealias Layout       = Constants.Layout
private typealias Localization = Localizable.Configuration

class ThemeManagerCell: UITableViewCell {

  // MARK: - Properties

  let label = UILabel()

  // MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.label.numberOfLines = 0
    self.contentView.addSubview(self.label)

    self.label.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16.0)
      make.left.equalToSuperview().offset(16.0)
      make.right.equalToSuperview()
    }

    let colorView = UIView()
    colorView.layer.cornerRadius = 24.0
    colorView.backgroundColor = UIColor.green
    self.contentView.addSubview(colorView)

    colorView.snp.makeConstraints { make in
      make.top.equalTo(self.label.snp.bottom).offset(8.0)
      make.left.equalToSuperview().offset(16.0)
      make.width.height.equalTo(48.0)
      make.bottom.equalToSuperview().offset(-16.0)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
