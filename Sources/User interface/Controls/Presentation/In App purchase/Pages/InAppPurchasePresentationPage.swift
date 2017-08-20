//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants    = InAppPurchasePresentationConstants
private typealias Layout       = Constants.Layout
private typealias Colors       = Constants.Colors
private typealias Localization = Constants.Localization

class InAppPurchasePresentationPage: UIViewController {

  // MARK: - Properties

  private let image:       UIImage
  private let titleText:   String
  private let captionText: String

  private let imageView    = UIImageView()
  private let titleLabel   = UILabel()
  private let captionLabel = UILabel()

  // MARK: - Init

  init(_ image: UIImage, _ title: String, _ caption: String) {
    self.image    = image
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
      make.top.equalToSuperview().offset(Layout.Page.Image.topOffset)
      make.centerX.equalToSuperview()
    }
  }

  private func initTitleLabel() {
    let attributes = Managers.theme.textAttributes(for: .bodyBold, alignment: .center, color: .background)
    titleLabel.attributedText = NSAttributedString(string: self.titleText, attributes: attributes)

    self.view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.imageView.snp.bottom).offset(Layout.Page.Title.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }
  }

  private func initCaptionLabel() {
    let attributes = Managers.theme.textAttributes(for: .caption, alignment: .center, lineSpacing: Layout.Page.Caption.lineSpacing, color: .background)
    self.captionLabel.attributedText = NSAttributedString(string: self.captionText, attributes: attributes)
    self.captionLabel.numberOfLines = 0

    self.view.addSubview(self.captionLabel)
    self.captionLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
      make.top.equalTo(titleLabel.snp.bottom).offset(Layout.Page.Caption.topOffset)
      make.bottom.equalToSuperview().offset(Layout.Page.Caption.bottomOffset)
    }
  }
}
