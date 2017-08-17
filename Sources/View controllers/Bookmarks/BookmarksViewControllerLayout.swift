//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants    = BookmarksViewControllerConstants
fileprivate typealias Layout       = Constants.Layout
fileprivate typealias Localization = Constants.Localization

extension BookmarksViewController {

  func initLayout() {
    Theme.current.applyCardPanelStyle(self.view)

    self.initHeader()
    self.initBookmarksTable()
    self.initBookmarksTablePlaceholder()
  }

  // MARK: - Private

  private func initHeader() {
    Theme.current.applyCardPanelHeaderStyle(self.headerView)
    self.view.addSubview(self.headerView)

    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.chevronView.state             = .down
    self.chevronView.color             = Theme.current.colorScheme.backgroundAccent
    self.chevronView.animationDuration = Constants.Animations.chevronDismissRelativeDuration
    self.view.addSubview(chevronView)

    self.chevronView.snp.makeConstraints { make in
      let chevronViewSize = ChevronView.nominalSize

      make.top.equalToSuperview().offset(Layout.Header.chevronY)
      make.centerX.equalToSuperview()
      make.width.equalTo(chevronViewSize.width)
      make.height.equalTo(chevronViewSize.height)
    }

    let titleAttributes           = Theme.current.textAttributes(for: .headline, color: .text)
    self.cardTitle.attributedText = NSAttributedString(string: Localization.cardTitle, attributes: titleAttributes)
    self.cardTitle.numberOfLines  = 0
    self.cardTitle.lineBreakMode  = .byWordWrapping
    self.headerView.addSubview(self.cardTitle)

    self.cardTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Header.topInset)
      make.bottom.equalToSuperview().offset(-Layout.Header.bottomInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
    }

    self.setEditButtonEdit()
    self.editButton.contentEdgeInsets = Layout.Header.editButtonInsets
    self.editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
    self.headerView.addSubview(self.editButton)

    self.editButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.cardTitle.snp.lastBaseline)
      make.right.equalToSuperview()
    }
  }

  private func initBookmarksTable() {
    self.bookmarksTable.register(BookmarkCell.self)
    self.bookmarksTable.separatorInset  = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    self.bookmarksTable.backgroundColor = Theme.current.colorScheme.background
    self.bookmarksTable.dataSource      = self.bookmarksTableDataSource
    self.bookmarksTable.delegate        = self
    self.view.insertSubview(self.bookmarksTable, belowSubview: self.headerView)

    self.bookmarksTable.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func initBookmarksTablePlaceholder() {
    // we cant use 'self.bookmarksTable.backgroundView' as this would result in incorrect left <-> right constraints
    self.view.addSubview(self.placeholderView)

    self.placeholderView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(Layout.Placeholder.leftInset)
      make.right.equalToSuperview().offset(-Layout.Placeholder.rightInset)
      make.centerY.equalTo(self.view)
    }

    let topTextAttributes = Theme.current.textAttributes(for: .subheadline, color: .text)
    self.placeholderTitle.attributedText = NSAttributedString(string: Localization.placeholderTitle, attributes: topTextAttributes)
    self.placeholderTitle.numberOfLines  = 0
    self.placeholderTitle.textAlignment  = .center
    self.placeholderTitle.lineBreakMode  = .byWordWrapping
    self.placeholderView.addSubview(self.placeholderTitle)

    self.placeholderTitle.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.placeholderContent.attributedText = self.createPlaceholderContent()
    self.placeholderContent.numberOfLines  = 0
    self.placeholderContent.textAlignment  = .center
    self.placeholderContent.lineBreakMode  = .byWordWrapping
    self.placeholderView.addSubview(self.placeholderContent)

    self.placeholderContent.snp.makeConstraints { make in
      make.top.equalTo(self.placeholderTitle.snp.bottom).offset(Layout.Placeholder.verticalSpacing)
      make.left.bottom.right.equalToSuperview()
    }
  }

  private func createPlaceholderContent() -> NSAttributedString {
    let textComponents = Localization.placeholderContent.components(separatedBy: "<star>")

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = Layout.Placeholder.lineSpacing
    paragraphStyle.alignment   = .center

    var textAttributes = Theme.current.textAttributes(for: .body, color: .text)
    textAttributes[NSParagraphStyleAttributeName] = paragraphStyle

    // build string
    let result = NSMutableAttributedString(string: textComponents[0], attributes: textAttributes)

    if textComponents.count > 1 {
      // https://stackoverflow.com/a/43192486
      let font      = textAttributes[NSFontAttributeName] as! UIFont
      let imageSize = abs(font.ascender) + abs(font.descender)
      let imageY    = font.ascender - imageSize

      let image = StyleKit.drawStarTemplateImage(size: CGSize(width: imageSize, height: imageSize))

      let attachment    = NSTextAttachment()
      attachment.image  = image
      attachment.bounds = CGRect(origin: CGPoint(x: 0.0, y: imageY), size: image.size)
      result.append(NSAttributedString(attachment: attachment))

      // add remaining text
      result.append(NSAttributedString(string: textComponents[1], attributes: textAttributes))
    }

    return result
  }

}
