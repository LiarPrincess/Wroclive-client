// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Constants = SettingsCard.Constants.MapTypeCell
private typealias Localization = Localizable.Settings.Table.MapType

/// Cell that allows user to select map type.
public final class SettingsMapTypeCell: UITableViewCell {

  // MARK: - Properties

  private struct Item {
    fileprivate let text: String
    fileprivate let value: MapType
  }

  private let items = [
    Item(text: Localization.standard, value: .standard),
    Item(text: Localization.satellite, value: .satellite),
    Item(text: Localization.hybrid, value: .hybrid)
  ]

  private let segmentedControl = UISegmentedControl()

  override public var alpha: CGFloat {
    get { return 1.0 }
    set {} // swiftlint:disable:this unused_setter_value
  }

  // MARK: - Init

  private let onValueChanged: (MapType) -> Void

  public init(onValueChanged: @escaping (MapType) -> Void) {
    self.onValueChanged = onValueChanged
    super.init(style: .default, reuseIdentifier: nil)

    self.selectionStyle = .none
    self.backgroundColor = ColorScheme.background

    for (index, item) in self.items.enumerated() {
      self.segmentedControl.insertSegment(withTitle: item.text,
                                          at: index,
                                          animated: false)
    }

    self.segmentedControl.selectedSegmentIndex = 0
    self.segmentedControl.addTarget(self,
                                    action: #selector(self.selectedIndexChanged),
                                    for: .valueChanged)

    self.contentView.translatesAutoresizingMaskIntoConstraints = false

    self.contentView.addSubview(self.segmentedControl)
    self.segmentedControl.snp.makeConstraints { make in
      // We need to set 'priority', otherwise we would get 'Encapsulated-Layout-Height'
      // auto layout error. See: https://stackoverflow.com/q/34009447
      make.top.equalToSuperview().offset(Constants.topInset).priority(.high)
      make.height.equalTo(Constants.nominalHeight).priority(.high)
      make.bottom.equalToSuperview().offset(-Constants.bottomInset).priority(.high)

      make.left.equalToSuperview().offset(Constants.leftInset)
      make.right.equalToSuperview().offset(-Constants.rightInset)
    }
  }

  // swiftlint:disable:next unavailable_function
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods

  @objc
  private func selectedIndexChanged(_ sender: UISegmentedControl) {
    let index = self.segmentedControl.selectedSegmentIndex
    assert(self.items.indices.contains(index))

    let item = self.items[index]
    self.onValueChanged(item.value)
  }

  public func setMapType(mapType: MapType) {
    guard let index = self.items.firstIndex(where: { $0.value == mapType }) else {
      fatalError("SettingsMapTypeCell does not support '\(mapType)'")
    }

    self.segmentedControl.selectedSegmentIndex = index
  }
}
