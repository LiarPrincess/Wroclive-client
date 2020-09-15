// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SafariServices

private typealias Localization = Localizable.Settings

public final class SettingsCard:
  UIViewController, UITableViewDataSource, UITableViewDelegate,
  SettingsCardViewType, CardPresentable {

  // MARK: - Properties

  public let headerView = ExtraLightVisualEffectView()
  public let titleLabel = UILabel()
  public let tableView = UITableView(frame: .zero, style: .grouped)

  private let mapTypeCell: SettingsMapTypeCell

  internal let viewModel: SettingsCardViewModel

  // MARK: - Init

  public init(viewModel: SettingsCardViewModel) {
    // swiftlint:disable:next trailing_closure
    self.mapTypeCell = SettingsMapTypeCell(
      onValueChanged: { viewModel.viewDidSelectMapType(mapType: $0) }
    )

    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    viewModel.setView(view: self)
  }

  // swiftlint:disable:next unavailable_function
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ViewDidLoad

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  // MARK: - ViewDidLayoutSubviews

  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.inset(scrollView: self.tableView, below: self.headerView)
  }

  // MARK: - Map type

  public func setMapType(mapType: MapType) {
    self.mapTypeCell.setMapType(mapType: mapType)
  }

  // MARK: - CardPresentable

  public var scrollView: UIScrollView? {
    return self.tableView
  }

  // MARK: - UITableView - cells

  public func numberOfSections(in tableView: UITableView) -> Int {
    return self.viewModel.sections.count
  }

  public func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
    let section = self.viewModel.sections[section]
    switch section {
    case .mapType:
      return 1
    case .general(let cells):
      return cells.count
    case .programming(let cells):
      return cells.count
    }
  }

  public func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = self.viewModel.sections[indexPath.section]
    switch section {
    case .mapType:
      return self.mapTypeCell

    case .general(let cells):
      let model = cells[indexPath.row]
      let isLastCellInSection = indexPath.row == cells.count - 1

      let cell = self.dequeueLinkCell(image: model.image,
                                      text: model.text,
                                      isLastCellInSection: isLastCellInSection,
                                      forRowAt: indexPath)
      return cell

    case .programming(let cells):
      let model = cells[indexPath.row]
      let isLastCellInSection = indexPath.row == cells.count - 1

      let cell = self.dequeueLinkCell(image: model.image,
                                      text: model.text,
                                      isLastCellInSection: isLastCellInSection,
                                      forRowAt: indexPath)
      return cell
    }
  }

  private func dequeueLinkCell(image: ImageAsset,
                               text: String,
                               isLastCellInSection: Bool,
                               forRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueCell(ofType: SettingsLinkCell.self,
                                          forIndexPath: indexPath)

    cell.update(image: image,
                text: text,
                isLastCellInSection: isLastCellInSection)

    return cell
  }

  public func tableView(_ tableView: UITableView,
                        didSelectRowAt indexPath: IndexPath) {
    // Deselect to simulate 'click', we do not want to actually select this row.
    self.tableView.deselectRow(at: indexPath, animated: true)
    self.viewModel.viewDidSelectRow(at: indexPath)
  }

  // MARK: - UITableView - Header

  public func tableView(_ tableView: UITableView,
                        heightForHeaderInSection sectionIndex: Int) -> CGFloat {
    // swiftlint:disable:next nesting type_name
    typealias C = Constants.SectionHeader

    guard let section = self.viewModel.getSection(at: sectionIndex) else {
      fatalError("No settings section at index: \(sectionIndex)")
    }

    let width = tableView.bounds.width - C.leftInset - C.rightInset
    let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)

    let text = NSAttributedString(string: section.text,
                                  attributes: C.titleAttributes)
    let textSize = text.boundingRect(with: bounds,
                                     options: .usesLineFragmentOrigin,
                                     context: nil)

    return textSize.height + C.topInset + C.bottomInset + 1.0
  }

  // We need this to hide section footer.
  public func tableView(_ tableView: UITableView,
                        heightForFooterInSection section: Int) -> CGFloat {
    return 1
  }

  // We need this to hide section footer.
  public func tableView(_ tableView: UITableView,
                        viewForFooterInSection section: Int) -> UIView? {
    return nil
  }

  public func tableView(_ tableView: UITableView,
                        viewForHeaderInSection sectionIndex: Int) -> UIView? {
    guard let section = self.viewModel.getSection(at: sectionIndex) else {
      fatalError("No settings section at index: \(sectionIndex)")
    }

    let view = tableView.dequeueSupplementary(ofType: SettingsSectionHeaderView.self)
    view.update(section: section)
    return view
  }
}
