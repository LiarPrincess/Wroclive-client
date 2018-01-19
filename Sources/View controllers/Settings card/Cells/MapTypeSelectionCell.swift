//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private typealias Layout       = MapTypeSelectionCellConstants.Layout
private typealias Localization = Localizable.Settings.Table.MapType

class MapTypeSelectionCell: UITableViewCell {

  // MARK: - Properties

  private lazy var segmentedControl: UISegmentedControl = {
    let mapTypes: [MapType] = [.map, .transport, .satelite]
    return UISegmentedControl(items: mapTypes.map(translationOf))
  }()

  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = Managers.theme.colors.background

    self.segmentedControl.selectedSegmentIndex = 0

    self.contentView.addSubview(self.segmentedControl)
    self.segmentedControl.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
      make.bottom.equalToSuperview().offset(-Layout.topInset)
    }
  }
}

// MARK: - Indices

private struct Indices {
  static let map        = 0
  static let transport  = 1
  static let satelite   = 2
}

private func indexOf(_ mapType: MapType) -> Int {
  switch mapType {
  case .map:       return Indices.map
  case .transport: return Indices.transport
  case .satelite:  return Indices.satelite
  }
}

private func translationOf(_ mapType: MapType) -> String {
  switch mapType {
  case .map:       return Localization.map
  case .transport: return Localization.transport
  case .satelite:  return Localization.satelite
  }
}

private func valueAt(_ index: Int) -> MapType {
  switch index {
  case Indices.map:       return .map
  case Indices.transport: return .transport
  case Indices.satelite:  return .satelite
  default: fatalError("Invalid index selected")
  }
}
