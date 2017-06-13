//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Layout = BookmarksViewControllerConstants.Layout.Cell

class BookmarkCell: UITableViewCell {

  //MARK: - Properties

  lazy var bookmarkName: UILabel = {
    let label = UILabel()
    label.setStyle(.subheadline)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()

  lazy var tramLines: UILabel = {
    let label = UILabel()
    label.setStyle(.bodyPrimary)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()

  lazy var busLines: UILabel = {
    let label = UILabel()
    label.setStyle(.bodyPrimary)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()

  //MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.contentView.addSubview(self.bookmarkName)
    self.contentView.addSubview(self.tramLines)
    self.contentView.addSubview(self.busLines)
    self.setNeedsUpdateConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Overriden

  // disable alpha, so we dont end up with transparent cells when reordering
  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  private var didSetupConstraints = false

  override func updateConstraints() {
    if !self.didSetupConstraints {
      self.bookmarkName.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(Layout.topPadding)
        make.left.equalToSuperview().offset(Layout.leftOffset)
        make.right.equalToSuperview().offset(-Layout.rightOffset)
      }

      self.tramLines.snp.makeConstraints { make in
        make.top.equalTo(self.bookmarkName.snp.bottom).offset(Layout.verticalSpacing)
        make.left.equalToSuperview().offset(Layout.leftOffset)
        make.right.equalToSuperview().offset(-Layout.rightOffset)
      }

      self.busLines.snp.makeConstraints { make in
        make.top.equalTo(self.tramLines.snp.bottom).offset(Layout.verticalSpacing)
        make.left.equalToSuperview().offset(Layout.leftOffset)
        make.right.equalToSuperview().offset(-Layout.rightOffset)
        make.bottom.equalToSuperview().offset(-Layout.bottomPadding)
      }

      self.didSetupConstraints = true
    }

    self.tramLines.snp.updateConstraints { make in
      let text = self.tramLines.text ?? ""
      let topOffset = text.isEmpty ? 0.0 : Layout.verticalSpacing
      make.top.equalTo(self.bookmarkName.snp.bottom).offset(topOffset)
    }

    self.busLines.snp.updateConstraints { make in
      let text = self.busLines.text ?? ""
      let topOffset = text.isEmpty ? 0.0 : Layout.verticalSpacing
      make.top.equalTo(self.tramLines.snp.bottom).offset(topOffset)
    }

    super.updateConstraints()
  }

  //MARK: - Methods

  func setUp(with viewModel: BookmarkCellViewModel) {
    self.bookmarkName.text = viewModel.bookmarkName
    self.setLineLabel(self.tramLines, text: viewModel.tramLines)
    self.setLineLabel(self.busLines,  text: viewModel.busLines)

    // update constraints, so that the layout will not break when we hide label
    self.setNeedsUpdateConstraints()
//    self.setNeedsLayout()
  }

  private func setLineLabel(_ label: UILabel, text: String) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = Layout.LinesLabel.lineSpacing
    paragraphStyle.alignment   = .center

    let labelText = NSMutableAttributedString(string: text)
    labelText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, labelText.length))

    label.isHidden       = text.isEmpty
    label.attributedText = labelText
  }

}
