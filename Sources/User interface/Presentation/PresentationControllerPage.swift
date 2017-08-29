//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Colors = PresentationControllerConstants.Colors

struct PresentationControllerPageParams {
  let image:   UIImage
  let title:   String
  let caption: String

  let leftOffset:  CGFloat
  let rightOffset: CGFloat

  let titleTopOffset:     CGFloat
  let captionTopOffset:   CGFloat
  let captionLineSpecing: CGFloat

  init(_ image: UIImage, _ title: String, _ caption: String,
       _ leftOffset: CGFloat, _ rightOffset: CGFloat,
       _ titleTopOffset: CGFloat,
       _ captionTopOffset: CGFloat, _ captionLineSpecing: CGFloat) {
    self.image   = image
    self.title   = title
    self.caption = caption

    self.leftOffset  = leftOffset
    self.rightOffset = rightOffset

    self.titleTopOffset     = titleTopOffset
    self.captionTopOffset   = captionTopOffset
    self.captionLineSpecing = captionLineSpecing
  }
}

class PresentationControllerPage: UIViewController {

  // MARK: - Properties

  private let parameters: PresentationControllerPageParams

  private let imageView      = UIImageView()
  private let labelContainer = UIView()
  private let titleLabel     = UILabel()
  private let captionLabel   = UILabel()

  // MARK: - Init

  init(_ parameters: PresentationControllerPageParams) {
    self.parameters = parameters
    super.init(nibName: nil, bundle: nil)

    self.imageView.image       = parameters.image
    self.imageView.contentMode = .scaleAspectFit

    self.titleLabel.attributedText = self.createAttributedTitle(parameters.title)
    self.titleLabel.numberOfLines  = 0

    self.captionLabel.attributedText = self.createAttributedCaption(parameters.caption)
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
      make.top.equalToSuperview()
      make.left.equalToSuperview().offset(parameters.leftOffset)
      make.right.equalToSuperview().offset(-parameters.rightOffset)
    }

    self.view.addSubview(self.labelContainer)
    self.labelContainer.snp.makeConstraints { make in
      make.top.equalTo(self.imageView.snp.bottom)
      make.bottom.equalToSuperview()
      make.left.equalToSuperview().offset(parameters.leftOffset)
      make.right.equalToSuperview().offset(-parameters.rightOffset)
    }

    self.titleLabel.setContentHuggingPriority(1000.0, for: .vertical)
    self.labelContainer.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(parameters.titleTopOffset)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }

    self.labelContainer.addSubview(self.captionLabel)
    self.captionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(parameters.captionTopOffset)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }
  }

  // MARK: - Text height

  func calculateRequiredTextHeight() -> CGFloat {
    let width = self.view.bounds.width - parameters.leftOffset - parameters.rightOffset
    let size  = CGSize(width : width, height : CGFloat.greatestFiniteMagnitude)

    let titleSize   = self.titleLabel  .attributedText!.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
    let captionSize = self.captionLabel.attributedText!.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)

    return parameters.titleTopOffset + titleSize.height
      + parameters.captionTopOffset + captionSize.height
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
    let color = Colors.textPrimary

    let textAttributes = Managers.theme.textAttributes(for: .caption, fontType: .text, alignment: .center, lineSpacing: parameters.captionLineSpecing, color: color)
    let iconAttributes = Managers.theme.textAttributes(for: .caption, fontType: .icon, alignment: .center, lineSpacing: parameters.captionLineSpecing, color: color)

    let starReplacement   = TextReplacement("<star>",   NSAttributedString(string: "\u{f006}", attributes: iconAttributes))
    let searchReplacement = TextReplacement("<search>", NSAttributedString(string: "\u{f002}", attributes: iconAttributes))

    return NSAttributedString(string: caption, attributes: textAttributes)
      .withReplacements([starReplacement, searchReplacement])
  }
}
