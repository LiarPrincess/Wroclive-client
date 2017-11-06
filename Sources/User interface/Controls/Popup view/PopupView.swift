//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import PromiseKit

private typealias Constants = PopupViewConstants
private typealias Layout    = Constants.Layout

class PopupView: UIVisualEffectView {

  // MARK: Init

  init(image: UIImage, title: String, caption: String) {
    let effect = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    super.init(effect: effect)
    self.initLayout(image: image, title: title, caption: caption)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Layout

  private func initLayout(image: UIImage, title: String, caption: String) {
    self.isUserInteractionEnabled = false
    self.layer.cornerRadius       = Layout.cornerRadius
    self.clipsToBounds            = true

    let imageView = UIImageView(image: image)
    imageView.tintColor = Managers.theme.colors.accentDark

    self.contentView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Image.topOffset)
      make.centerX.equalToSuperview()
      make.width.equalTo(Layout.Image.size.width)
      make.height.equalTo(Layout.Image.size.height)
    }

    let titleLabel = UILabel()
    titleLabel.numberOfLines  = 0
    titleLabel.attributedText = self.createAttributedTitle(title)

    self.contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(Layout.Title.topOffset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
      make.width.equalTo(Layout.Title.width)
    }

    let captionLabel = UILabel()
    captionLabel.numberOfLines  = 0
    captionLabel.attributedText = self.createAttributedCaption(caption)

    self.contentView.addSubview(captionLabel)
    captionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(Layout.Caption.topOffset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
      make.bottom.equalToSuperview().offset(-Layout.Caption.bottomOffset)
    }
  }

  // MARK: - Attributed texts

  private func createAttributedTitle(_ title: String) -> NSAttributedString {
    let attributes = Managers.theme.textAttributes(for: .subheadline, alignment: .center, color: .accentDark)
    return NSAttributedString(string: title, attributes: attributes)
  }

  private func createAttributedCaption(_ caption: String) -> NSAttributedString {
    let alignment   = NSTextAlignment.center
    let color       = TextColor.accentDark
    let lineSpacing = CGFloat(Layout.Caption.lineSpacing)

    let textAttributes = Managers.theme.textAttributes(for: .caption, fontType: .text, alignment: alignment, lineSpacing: lineSpacing, color: color)
    let iconAttributes = Managers.theme.textAttributes(for: .caption, fontType: .icon, alignment: alignment, lineSpacing: lineSpacing, color: color)

    let starReplacement = TextReplacement("<star>", NSAttributedString(string: "\u{f006}", attributes: iconAttributes))

    return NSAttributedString(string: caption, attributes: textAttributes)
      .withReplacements([starReplacement])
  }
}
