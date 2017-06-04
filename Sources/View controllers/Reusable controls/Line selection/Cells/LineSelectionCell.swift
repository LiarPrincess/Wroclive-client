//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Layout = LineSelectionControlConstants.Layout.Cell

class LineSelectionCell: UICollectionViewCell {

  //MARK: - Properties

  var lineName = UILabel()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Overriden

  override var isSelected: Bool {
    didSet {
      self.lineName.textColor = isSelected ? self.backgroundColor! : self.tintColor
    }
  }

  //MARK: - Methods

  func setUp(with viewModel: LineSelectionCellViewModel) {
    self.lineName.text = viewModel.lineName
  }

}

//MARK: - UI Init

extension LineSelectionCell {

  fileprivate func initLayout() {
    self.tintColor       = UIApplication.shared.keyWindow!.tintColor
    self.backgroundColor = UIColor.white

    self.selectedBackgroundView = UIView()
    self.selectedBackgroundView?.backgroundColor = self.tintColor

    self.lineName.numberOfLines = 1
    self.lineName.font          = FontManager.instance.lineSelectionCellContent
    self.lineName.textAlignment = .center
    self.lineName.textColor     = self.tintColor

    self.layer.cornerRadius = Layout.cornerRadius
    self.layer.borderWidth  = Layout.borderWidth
    self.layer.borderColor  = self.tintColor?.cgColor
    self.clipsToBounds      = true

    self.addSubview(self.lineName)

    self.lineName.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}

