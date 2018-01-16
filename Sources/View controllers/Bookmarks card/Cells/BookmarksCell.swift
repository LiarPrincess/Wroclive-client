//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private typealias Layout     = BookmarksCellConstants.Layout
private typealias TextStyles = BookmarksCellConstants.TextStyles

// https://stackoverflow.com/a/25967370 - preferredMaxLayoutWidth
// https://stackoverflow.com/a/18746930 - auto layout for UITableView
// https://stackoverflow.com/a/2063776  - recalculate cell height

class BookmarksCell: UITableViewCell {

  // MARK: - Properties

  private let nameLabel  = UILabel()
  private let linesLabel = UILabel()

  let viewModel = BookmarksCellViewModel()
  private let disposeBag = DisposeBag()

  // disable alpha, so we dont end up with transparent cells when reordering
  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
    self.initBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = Managers.theme.colors.background
    self.nameLabel.numberOfLines  = 0
    self.linesLabel.numberOfLines = 0

    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }

    self.contentView.addSubview(self.linesLabel)
    self.linesLabel.snp.makeConstraints { make in
      make.top.equalTo(self.nameLabel.snp.bottom).offset(Layout.LinesLabel.topMargin)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
      make.bottom.equalToSuperview().offset(-Layout.bottomInset)
    }
  }

  private func initBindings() {
    self.viewModel.outputs.name
      .map { NSAttributedString(string: $0, attributes: TextStyles.name) }
      .drive(self.nameLabel.rx.attributedText)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.lines
      .map { NSAttributedString(string: $0, attributes: TextStyles.lines) }
      .drive(self.linesLabel.rx.attributedText)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Overriden

  override func willTransition(to state: UITableViewCellStateMask) {
    super.willTransition(to: state)
    self.disallowIndentWhileEditing()
  }

  override func layoutSubviews() {
    self.updateLabelPreferredWidths()
    super.layoutSubviews()
    self.disallowIndentWhileEditing()
  }

  private func disallowIndentWhileEditing() {
    if self.isEditing {
      self.contentView.frame.origin.x   = self.bounds.minX
      self.contentView.frame.size.width = self.bounds.maxX
    }
  }

  private func updateLabelPreferredWidths() {
    // hack: we need to calculate from cell not content view as content view will shrink on edit
    let labelWidth = self.bounds.width - Layout.leftInset - Layout.rightInset
    self.nameLabel.preferredMaxLayoutWidth  = labelWidth
    self.linesLabel.preferredMaxLayoutWidth = labelWidth
  }
}