//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

//MARK: - BookmarkCellViewModel

struct BookmarkCellViewModel {
  let bookmarkName: String
  let tramLines: String
  let busLines: String

  init(from bookmark: Bookmark) {
    self.bookmarkName = bookmark.name
    self.tramLines = BookmarkCellViewModel.concatLineNames(bookmark.lines, ofType: .tram)
    self.busLines = BookmarkCellViewModel.concatLineNames(bookmark.lines, ofType: .bus)
  }

  private static func concatLineNames(_ lines: [Line], ofType lineType: LineType) -> String {
    return lines.filter { $0.type == lineType }
      .map { $0.name }
      .joined(separator: "  ")
  }
  
}

//MARK: - BookmarkCell

class BookmarkCell: UITableViewCell {

  //MARK: - Properties

  fileprivate let stackView = UIStackView()
  fileprivate let bookmarkName = UILabel()
  fileprivate let tramLines    = UILabel()
  fileprivate let busLines     = UILabel()

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

  //MARK: - Methods

  func setUp(with viewModel: BookmarkCellViewModel) {
    self.bookmarkName.text = viewModel.bookmarkName

    self.tramLines.text = viewModel.tramLines
    self.tramLines.isHidden = viewModel.tramLines.isEmpty

    self.busLines.text = viewModel.busLines
    self.busLines.isHidden = viewModel.busLines.isEmpty
  }

}

//MARK: - UI Init

extension BookmarkCell {

  fileprivate func initLayout() {
    self.initStackView()
    
    self.initLabel(self.bookmarkName)
    self.initLabel(self.tramLines)
    self.initLabel(self.busLines)

    let textColor = UIApplication.shared.keyWindow!.tintColor
    self.tramLines.textColor = textColor
    self.busLines.textColor = textColor

    self.bookmarkName.font = FontManager.instance.bookmarkCellTitle
    self.tramLines.font    = FontManager.instance.bookmarkCellContent
    self.busLines.font     = FontManager.instance.bookmarkCellContent

    self.stackView.addArrangedSubview(self.bookmarkName)
    self.stackView.addArrangedSubview(self.tramLines)
    self.stackView.addArrangedSubview(self.busLines)
  }

  private func initStackView() {
    self.stackView.axis = .vertical
    self.stackView.alignment = .fill
    self.stackView.spacing = 5.0
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
