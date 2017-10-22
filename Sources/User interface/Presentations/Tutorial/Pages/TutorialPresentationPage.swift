//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Constants = TutorialPresentationConstants
private typealias Layout    = Constants.Layout.Page

class TutorialPresentationPage: UIViewController {

  // MARK: - Properties

  private let deviceImageView: DeviceImageView

  private let labelContainer = UIView()
  private let titleLabel     = UILabel()
  private let captionLabel   = UILabel()

  // MARK: - Init

  init(content deviceImageContent: UIView, title: String, caption: String) {
    self.deviceImageView = DeviceImageView(content: deviceImageContent)
    super.init(nibName: nil, bundle: nil)

    self.titleLabel.attributedText = self.createAttributedTitle(title)
    self.titleLabel.numberOfLines  = 0

    self.captionLabel.attributedText = self.createAttributedCaption(caption)
    self.captionLabel.numberOfLines  = 0
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.clipsToBounds = true

    self.deviceImageView.setContentCompressionResistancePriority(100.0, for: .vertical)

    self.view.addSubview(self.deviceImageView)
    self.deviceImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.leftOffset)
    }

    self.view.addSubview(self.labelContainer)
    self.labelContainer.snp.makeConstraints { make in
      make.top.equalTo(self.deviceImageView.snp.bottom)
      make.bottom.equalToSuperview()
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }

    self.titleLabel.setContentHuggingPriority(1000.0, for: .vertical)
    self.labelContainer.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Title.topOffset)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }

    self.labelContainer.addSubview(self.captionLabel)
    self.captionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(Layout.Caption.topOffset)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }
  }

  // MARK: - Text height

  func calculateMinTextHeight() -> CGFloat {
    let width = self.view.bounds.width - Layout.leftOffset - Layout.rightOffset
    let size  = CGSize(width : width, height : CGFloat.greatestFiniteMagnitude)

    let titleSize   = self.titleLabel  .attributedText!.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
    let captionSize = self.captionLabel.attributedText!.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)

    return Layout.Title.topOffset   + titleSize.height
      + Layout.Caption.topOffset + captionSize.height
      + 1.0 // because of reasons
  }

  func guaranteeMinTextHeight(_ height: CGFloat) {
    self.labelContainer.snp.makeConstraints { make in
      make.height.equalTo(height)
    }
  }

  // MARK: - Attributed texts

  private func createAttributedTitle(_ title: String) -> NSAttributedString {
    let attributes = Managers.theme.textAttributes(for: .bodyBold, alignment: .center, color: .presentationPrimary)
    return NSAttributedString(string: title, attributes: attributes)
  }

  private func createAttributedCaption(_ caption: String) -> NSAttributedString {
    let alignment   = NSTextAlignment.center
    let color       = TextColor.presentationSecondary
    let lineSpacing = Layout.Caption.lineSpacing

    let textAttributes = Managers.theme.textAttributes(for: .caption, fontType: .text, alignment: alignment, lineSpacing: lineSpacing, color: color)
    let iconAttributes = Managers.theme.textAttributes(for: .caption, fontType: .icon, alignment: alignment, lineSpacing: lineSpacing, color: color)

    let starReplacement   = TextReplacement("<star>",   NSAttributedString(string: "\u{f006}", attributes: iconAttributes))
    let searchReplacement = TextReplacement("<search>", NSAttributedString(string: "\u{f002}", attributes: iconAttributes))

    return NSAttributedString(string: caption, attributes: textAttributes)
      .withReplacements([starReplacement, searchReplacement])
  }
}
