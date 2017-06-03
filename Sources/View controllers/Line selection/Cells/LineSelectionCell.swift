//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = LineSelectionViewControllerConstants

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
      self.lineName.textColor = isSelected ? UIColor.white : self.tintColor
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
    self.tintColor = UIApplication.shared.keyWindow!.tintColor

    self.selectedBackgroundView = UIView()
    self.selectedBackgroundView?.backgroundColor = self.tintColor

    self.lineName.numberOfLines = 1
    self.lineName.font          = FontManager.instance.lineSelectionCellContent
    self.lineName.textAlignment = .center
    self.lineName.textColor     = self.tintColor

    self.layer.cornerRadius = Constants.Layout.LineCollection.Cell.cornerRadius
    self.layer.borderWidth  = Constants.Layout.LineCollection.Cell.borderWidth
    self.layer.borderColor  = self.tintColor?.cgColor
    self.clipsToBounds      = true

    self.addSubview(self.lineName)

    self.lineName.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}

