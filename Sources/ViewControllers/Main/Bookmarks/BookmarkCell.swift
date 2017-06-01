//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Layout = BookmarksViewControllerConstants.Layout.Cell

//MARK: - BookmarkCellViewModel

struct BookmarkCellViewModel {
  let bookmarkName: String
  let tramLines:    String
  let busLines:     String

  init(from bookmark: Bookmark) {
    self.bookmarkName = bookmark.name
    self.tramLines    = BookmarkCellViewModel.concatNames(bookmark.lines, ofType: .tram)
    self.busLines     = BookmarkCellViewModel.concatNames(bookmark.lines, ofType: .bus)
  }

  private static func concatNames(_ lines: [Line], ofType lineType: LineType) -> String {
    return lines.filter { $0.type == lineType }
      .map { $0.name }
      .joined(separator: "  ")
  }
  
}

//MARK: - BookmarkCell

class BookmarkCell: UITableViewCell {

  //MARK: - Properties

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
    get { return 1.0 }
    set { }
  }

  //MARK: - Methods

  func setUp(with viewModel: BookmarkCellViewModel) {
    self.bookmarkName.text  = viewModel.bookmarkName

    let hasTramLines        = !viewModel.tramLines.isEmpty
    self.tramLines.text     = viewModel.tramLines
    self.tramLines.isHidden = !hasTramLines

    self.tramLines.snp.updateConstraints { make in
      let topOffset = hasTramLines ? Layout.TramLines.topOffset : 0.0
      make.top.equalTo(self.bookmarkName.snp.bottom).offset(topOffset)
    }

    let hasBusLines         = !viewModel.busLines.isEmpty
    self.busLines.text      = viewModel.busLines
    self.busLines.isHidden  = !hasBusLines

    self.busLines.snp.updateConstraints { make in
      let topOffset = hasBusLines ? Layout.BusLines.topOffset : 0.0
      make.top.equalTo(self.tramLines.snp.bottom).offset(topOffset)
    }
  }

}

//MARK: - UI Init

extension BookmarkCell {

  fileprivate func initLayout() {
    let tintColor = UIApplication.shared.keyWindow!.tintColor

    self.initLabel(self.bookmarkName)
    self.bookmarkName.font = FontManager.instance.bookmarkCellTitle
    self.addSubview(self.bookmarkName)

    self.bookmarkName.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }

    self.initLabel(self.tramLines)
    self.tramLines.textColor = tintColor
    self.tramLines.font      = FontManager.instance.bookmarkCellContent
    self.addSubview(self.tramLines)

    self.tramLines.snp.makeConstraints { make in
      make.top.equalTo(self.bookmarkName.snp.bottom).offset(Layout.TramLines.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }

    self.initLabel(self.busLines)
    self.busLines.textColor  = tintColor
    self.busLines.font       = FontManager.instance.bookmarkCellContent
    self.addSubview(self.busLines)

    self.busLines.snp.makeConstraints { make in
      make.top.equalTo(self.tramLines.snp.bottom).offset(Layout.BusLines.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
      make.bottom.equalToSuperview().offset(-Layout.bottomOffset)
    }
  }

  private func initLabel(_ label: UILabel) {
    label.numberOfLines = 0
    label.textAlignment = .center
  }

}
