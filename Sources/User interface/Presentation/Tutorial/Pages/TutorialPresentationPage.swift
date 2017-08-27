//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Layout       = TutorialPresentationConstants.Layout
private typealias Colors       = PresentationConstants.Colors
//private typealias Localization = Localizable.Presentation.InAppPurchase

class TutorialPresentationPage: UIViewController {

  // MARK: - Properties

  private let image:       UIImage
  private let titleText:   String
  private let captionText: String

  private let imageView    = UIImageView()
  private let titleLabel   = UILabel()
  private let captionLabel = UILabel()

  // MARK: - Init

  init(_ image: UIImage, _ title: String, _ caption: String) {
    self.image       = image
    self.titleText   = title
    self.captionText = caption
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.clipsToBounds = true
    self.initImage()
    self.initTitleLabel()
    self.initCaptionLabel()
  }

  private func initImage() {
    self.imageView.image       = self.image
    self.imageView.contentMode = .scaleAspectFit
    self.imageView.setContentCompressionResistancePriority(100, for: .vertical)

    self.view.addSubview(self.imageView)
    self.imageView.snp.makeConstraints { make in
      let screenHeight = UIScreen.main.bounds.height
      let topInset     = -1.0 * screenHeight * Layout.Page.Image.hiddenPercent

      make.top.equalToSuperview().offset(topInset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }
  }

  private func initTitleLabel() {
    let attributes = Managers.theme.textAttributes(for: .bodyBold, alignment: .center, color: Colors.textPrimary)
    titleLabel.attributedText = NSAttributedString(string: self.titleText, attributes: attributes)

    self.view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.imageView.snp.bottom).offset(Layout.Page.Title.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }
  }

  private func initCaptionLabel() {
    self.captionLabel.attributedText = self.createCaptionLabelText(self.captionText)
    self.captionLabel.numberOfLines  = 0

    self.view.addSubview(self.captionLabel)
    self.captionLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
      make.top.equalTo(titleLabel.snp.bottom).offset(Layout.Page.Caption.topOffset)
    }
  }

  func createCaptionLabelText(_ text: String) -> NSAttributedString {
    let color       = Colors.textPrimary
    let lineSpacing = Layout.Page.Caption.lineSpacing

    let textAttributes = Managers.theme.textAttributes(for: .caption, fontType: .text, alignment: .center, lineSpacing: lineSpacing, color: color)
    let iconAttributes = Managers.theme.textAttributes(for: .caption, fontType: .icon, alignment: .center, lineSpacing: lineSpacing, color: color)

    let starReplacement   = TextReplacement("<star>",   NSAttributedString(string: "\u{f002}", attributes: iconAttributes))
    let searchReplacement = TextReplacement("<search>", NSAttributedString(string: "\u{f006}", attributes: iconAttributes))

    return NSAttributedString(string: text, attributes: textAttributes)
      .withReplacements([starReplacement, searchReplacement])
  }
}
