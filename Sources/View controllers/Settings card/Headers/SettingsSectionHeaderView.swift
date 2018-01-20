//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout = SettingsSectionHeaderViewConstants.Layout

class SettingsSectionHeaderView: UITableViewHeaderFooterView {

  // MARK: - Properties

  let titleLabel = UILabel()

  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.contentView.backgroundColor = Managers.theme.colors.background

    self.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.bottom.equalToSuperview().offset(-Layout.bottomInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }
  }
}
