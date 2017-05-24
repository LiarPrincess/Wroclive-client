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

  //MARK: - Overriden

  // disable alpha, so we dont end up with transparent cells when reordering
  override var alpha: CGFloat {
    didSet { super.alpha = 1 }
  }

}

//MARK: - UI Init

extension BookmarkCell {

  fileprivate func initLayout() {
    self.initStackView()
    
    self.initLabel(self.bookmarkName)
    self.initLabel(self.tramLines)
    self.initLabel(self.busLines)

    self.bookmarkName.font = FontManager.instance.bookmarkCellTitle
    self.tramLines.font = FontManager.instance.bookmarkCellContent
    self.busLines.font = FontManager.instance.bookmarkCellContent

    let textColor = UIApplication.shared.keyWindow!.tintColor
    self.tramLines.textColor = textColor
    self.busLines.textColor = textColor

    self.stackView.addArrangedSubview(self.bookmarkName)
    self.stackView.addArrangedSubview(self.tramLines)
    self.stackView.addArrangedSubview(self.busLines)
  }

  private func initStackView() {
    self.stackView.axis = .vertical
    self.stackView.alignment = .fill
    self.stackView.spacing = 2.0
    self.stackView.distribution = .equalSpacing
    self.addSubview(self.stackView)

    self.stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5.0, left: 40.0, bottom: 5.0, right: 40.0))
    }
  }

  private func initLabel(_ label: UILabel) {
    label.numberOfLines = 0
    label.textAlignment = .center
  }

}
