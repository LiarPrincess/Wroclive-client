// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SafariServices

private typealias Layout       = SettingsCardConstants.Layout
private typealias TextStyles   = SettingsCardConstants.TextStyles
private typealias Localization = Localizable.Settings

public final class SettingsCard:
  UIViewController, UITableViewDataSource, UITableViewDelegate,
  CustomCardPanelPresentable
{
  // MARK: - Properties

  public lazy var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  public let titleLabel = UILabel()
  public let tableView = UITableView(frame: .zero, style: .grouped)

  internal let viewModel: SettingsCardViewModel
  internal let environment: Environment

  // MARK: - Init

  public init(viewModel: SettingsCardViewModel, environment: Environment) {
    self.viewModel = viewModel
    self.environment = environment
    super.init(nibName: nil, bundle: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ViewDidLoad

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  // MARK: - ViewDidLayoutSubviews

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetTableViewContentBelowHeaderView()
  }

  private func insetTableViewContentBelowHeaderView() {
    let currentInset = self.tableView.contentInset
    let headerHeight = self.headerView.bounds.height

    if currentInset.top < headerHeight {
      let newInset = UIEdgeInsets(top: headerHeight,
                                  left: currentInset.left,
                                  bottom: currentInset.bottom,
                                  right: currentInset.right)
      self.tableView.contentInset = newInset
      self.tableView.scrollIndicatorInsets = newInset

      // Scroll up to preserve current scroll position
      let currentOffset = self.tableView.contentOffset
      let newOffset = CGPoint(x: currentOffset.x,
                              y: currentOffset.y + currentInset.top - headerHeight)
      self.tableView.setContentOffset(newOffset, animated: false)
    }
  }

  // MARK: - CustomCardPanelPresentable

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
    return section.cells.count
  }

  public func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let (section, cellKind) = self.viewModel.getCell(at: indexPath) else {
      fatalError("No settings cell at: \(indexPath)")
    }

    let cell = self.tableView.dequeueCell(ofType: SettingsTextCell.self,
                                          forIndexPath: indexPath)

    let isLastCellInSection = indexPath.row == section.cells.count - 1
    cell.update(kind: cellKind,
                isLastCellInSection: isLastCellInSection,
                device: self.environment.device)
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
    typealias HeaderLayout = SettingsSectionHeaderViewConstants.Layout

    guard let section = self.viewModel.getSection(at: sectionIndex) else {
      fatalError("No settings section at index: \(sectionIndex)")
    }

    let width = tableView.bounds.width - HeaderLayout.leftInset - HeaderLayout.rightInset
    let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)

    let text = NSAttributedString(string: section.kind.text,
                                  attributes: TextStyles.sectionTitle)
    let textSize = text.boundingRect(with: bounds,
                                     options: .usesLineFragmentOrigin,
                                     context: nil)

    return textSize.height + HeaderLayout.topInset + HeaderLayout.bottomInset + 1.0
  }

  public func tableView(_ tableView: UITableView,
                        heightForFooterInSection section: Int) -> CGFloat {
    return 1
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
