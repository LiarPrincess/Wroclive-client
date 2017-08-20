//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class InAppPurchasePresentationPage: UIViewController {

  // MARK: - Properties

  private let image:       UIImage
  private let titleText:   String
  private let captionText: String

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

  }

  private func initTitleLabel() {
    let attributes = Managers.theme.textAttributes(for: .bodyBold, alignment: .center, color: .background)
    titleLabel.attributedText = NSAttributedString(string: self.titleText, attributes: attributes)

    self.view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(16.0)
      make.right.equalToSuperview().offset(-16.0)
    }
  }

  private func initCaptionLabel() {
    let attributes = Managers.theme.textAttributes(for: .caption, alignment: .center, lineSpacing: 2.0, color: .background)
    self.captionLabel.attributedText = NSAttributedString(string: self.captionText, attributes: attributes)
    self.captionLabel.numberOfLines = 0

    self.view.addSubview(self.captionLabel)
    self.captionLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(16.0)
      make.right.equalToSuperview().offset(-16.0)
      make.top.equalTo(titleLabel.snp.bottom).offset(5.0)
      make.bottom.equalToSuperview()
    }
  }
}
