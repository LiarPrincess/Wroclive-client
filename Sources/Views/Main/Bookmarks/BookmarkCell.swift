//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import SnapKit

class BookmarkCell: UITableViewCell {

  //MARK: - Properties

  static let identifier = "BookmarkCell"

  fileprivate let stackView = UIStackView()
  let bookmarkName = UILabel()
  let tramLines = UILabel()
  let busLines = UILabel()

  //MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

//MARK: - UI Init

extension BookmarkCell {

  fileprivate func initLayout() {
    self.stackView.axis = .vertical
    self.stackView.alignment = .fill
    self.stackView.spacing = 5.0
    self.stackView.distribution = .equalSpacing
    self.addSubview(self.stackView)

    self.stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5.0, left: 30.0, bottom: 5.0, right: 30.0))
    }

    applyLabelSettings(self.bookmarkName)
    applyLabelSettings(self.tramLines)
    applyLabelSettings(self.busLines)

    self.stackView.addArrangedSubview(self.bookmarkName)
    self.stackView.addArrangedSubview(self.tramLines)
    self.stackView.addArrangedSubview(self.busLines)
  }

  private func applyLabelSettings(_ label: UILabel) {
    label.numberOfLines = 0
    label.textAlignment = .center
  }

}
