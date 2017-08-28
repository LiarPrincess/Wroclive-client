//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Layout       = InAppPurchasePresentationConstants.Layout
private typealias Colors       = PresentationConstants.Colors
private typealias Localization = Localizable.Presentation.InAppPurchase

class InAppPurchasePresentationPage: UIViewController {

  // MARK: - Properties

  private let imageView    = UIImageView()
  private let titleLabel   = UILabel()
  private let captionLabel = UILabel()

  // MARK: - Init

  init(_ image: UIImage, _ title: String, _ caption: String) {
    super.init(nibName: nil, bundle: nil)

    self.imageView.image       = image
    self.imageView.contentMode = .scaleAspectFit

    let titleAttributes = Managers.theme.textAttributes(for: .bodyBold, alignment: .center, color: Colors.textPrimary)
    self.titleLabel.attributedText = NSAttributedString(string: title, attributes: titleAttributes)
    self.titleLabel.numberOfLines  = 0

    let captionAttributes = Managers.theme.textAttributes(for: .caption, alignment: .center, lineSpacing: Layout.Page.Caption.lineSpacing, color: Colors.textPrimary)
    self.captionLabel.attributedText = NSAttributedString(string: caption, attributes: captionAttributes)
    self.captionLabel.numberOfLines  = 0
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.imageView.setContentCompressionResistancePriority(100, for: .vertical)
    self.view.addSubview(self.imageView)
    self.imageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Page.Image.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }

    self.view.addSubview(titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.imageView.snp.bottom).offset(Layout.Page.Title.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }

    self.view.addSubview(self.captionLabel)
    self.captionLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
      make.top.equalTo(titleLabel.snp.bottom).offset(Layout.Page.Caption.topOffset)
      make.bottom.equalToSuperview()
    }
  }
}
