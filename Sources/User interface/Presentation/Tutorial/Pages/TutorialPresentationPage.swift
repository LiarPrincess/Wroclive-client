//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout = TutorialPresentationConstants.Layout
private typealias Colors = PresentationConstants.Colors

class TutorialPresentationPage: UIViewController {

  // MARK: - Properties

  private let imageView      = UIImageView()
  private let labelContainer = UIView()
  private let titleLabel     = UILabel()
  private let captionLabel   = UILabel()

  // MARK: - Init

  init(_ image: UIImage, _ title: String, _ caption: String) {
    super.init(nibName: nil, bundle: nil)

    self.imageView.image       = image
    self.imageView.contentMode = .scaleAspectFit

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

    self.imageView.setContentCompressionResistancePriority(100.0, for: .vertical)
    self.view.addSubview(self.imageView)
    self.imageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Page.Image.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }

    self.view.addSubview(self.labelContainer)
    self.labelContainer.snp.makeConstraints { make in
      make.top.equalTo(self.imageView.snp.bottom)
      make.bottom.equalToSuperview()
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }

    self.titleLabel.setContentHuggingPriority(1000.0, for: .vertical)
    self.labelContainer.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Page.Title.topOffset)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }

    self.labelContainer.addSubview(self.captionLabel)
    self.captionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(Layout.Page.Caption.topOffset)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }
  }

  // MARK: - Text height

  func calculateRequiredTextHeight() -> CGFloat {
    let width = self.view.bounds.width - Layout.leftOffset - Layout.rightOffset
    let size  = CGSize(width : width, height : CGFloat.greatestFiniteMagnitude)

    let titleSize   = self.titleLabel  .attributedText!.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
    let captionSize = self.captionLabel.attributedText!.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)

    return Layout.Page.Title.topOffset   + titleSize.height
      + Layout.Page.Caption.topOffset + captionSize.height
      + 1.0 // because of reasons
  }

  func guaranteeMinTextHeight(_ height: CGFloat) {
    self.labelContainer.snp.makeConstraints { make in
      make.height.equalTo(height)
    }
  }

  // MARK: - Attributed texts

  private func createAttributedTitle(_ title: String) -> NSAttributedString {
    let attributes = Managers.theme.textAttributes(for: .bodyBold, alignment: .center, color: Colors.textPrimary)
    return NSAttributedString(string: title, attributes: attributes)
  }

  private func createAttributedCaption(_ caption: String) -> NSAttributedString {
    let color       = Colors.textPrimary
    let lineSpacing = Layout.Page.Caption.lineSpacing

    let textAttributes = Managers.theme.textAttributes(for: .caption, fontType: .text, alignment: .center, lineSpacing: lineSpacing, color: color)
    let iconAttributes = Managers.theme.textAttributes(for: .caption, fontType: .icon, alignment: .center, lineSpacing: lineSpacing, color: color)

    let starReplacement   = TextReplacement("<star>",   NSAttributedString(string: "\u{f002}", attributes: iconAttributes))
    let searchReplacement = TextReplacement("<search>", NSAttributedString(string: "\u{f006}", attributes: iconAttributes))

    return NSAttributedString(string: caption, attributes: textAttributes)
      .withReplacements([starReplacement, searchReplacement])
  }
}
