//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private typealias Layout       = SettingsMapTypeCellConstants.Layout
private typealias Localization = Localizable.Settings.Table.MapType

class SettingsMapTypeCell: UITableViewCell {

  // MARK: - Properties

  private lazy var segmentedControl: UISegmentedControl = {
    let mapTypes: [MapType] = [.standard, .satellite, .hybrid]
    return UISegmentedControl(items: mapTypes.map(translationOf))
  }()

  var selectedValue: MapType {
    get { return valueAt(self.segmentedControl.selectedSegmentIndex) }
    set { self.segmentedControl.selectedSegmentIndex = indexOf(newValue) }
  }

  var selectedValueChanged: Observable<MapType> {
    return self.segmentedControl.rx.selectedSegmentIndex
      .map(valueAt)
      .skip(1) // skip initial value
  }

  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
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
      make.height.equalTo(Layout.nominalHeight)
      make.bottom.equalToSuperview().offset(-Layout.bottomInset)

      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }
  }
}

// MARK: - Indices

private enum Indices {
  static let standard  = 0
  static let satellite = 1
  static let hybrid    = 2
}

private func indexOf(_ mapType: MapType) -> Int {
  switch mapType {
  case .standard:  return Indices.standard
  case .satellite: return Indices.satellite
  case .hybrid:    return Indices.hybrid
  }
}

private func translationOf(_ mapType: MapType) -> String {
  switch mapType {
  case .standard:  return Localization.standard
  case .satellite: return Localization.satellite
  case .hybrid:    return Localization.hybrid
  }
}

private func valueAt(_ index: Int) -> MapType {
  switch index {
  case Indices.standard:  return .standard
  case Indices.satellite: return .satellite
  case Indices.hybrid:    return .hybrid
  default: fatalError("Invalid index selected")
  }
}
