//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private typealias Layout = LineSelectorHeaderViewConstants.Layout

class LineSelectorHeaderView: UICollectionReusableView {

  // MARK: - Properties

  private let textLabel = UILabel()

  let viewModel = LineSelectorHeaderViewModel()
  private let disposeBag = DisposeBag()

  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
    self.initBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = Managers.theme.colors.background

    self.textLabel.numberOfLines = 0
    self.textLabel.isUserInteractionEnabled = false

    self.addSubview(self.textLabel)
    self.textLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.left.right.equalToSuperview()
    }
  }

  private func initBindings() {
    self.viewModel.outputs.text
      .drive(self.textLabel.rx.attributedText)
      .disposed(by: self.disposeBag)
  }
}
