//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private typealias Layout = LineSelectorCellConstants.Layout

class LineSelectorCell: UICollectionViewCell {

  // MARK: - Properties

  private let textLabel = UILabel()

  let viewModel = LineSelectorCellViewModel()
  private let disposeBag = DisposeBag()

  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  override var isSelected: Bool {
    didSet { self.viewModel.inputs.isSelected.onNext(isSelected) }
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
    self.selectedBackgroundView = UIView()
    self.selectedBackgroundView?.backgroundColor    = Managers.theme.colors.tint
    self.selectedBackgroundView?.layer.cornerRadius = Layout.cornerRadius

    self.textLabel.numberOfLines = 1
    self.textLabel.isUserInteractionEnabled = false

    self.contentView.addSubview(self.textLabel)
    self.textLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func initBindings() {
    self.viewModel.outputs.text
      .drive(self.textLabel.rx.attributedText)
      .disposed(by: self.disposeBag)
  }
}
