//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Layout = ColorSelectionViewControllerConstants.Layout

class ColorSelectionViewController: UIViewController {

  // MARK: - Properties

  let scrollView        = UIScrollView()
  let scrollViewContent = UIView()

  let themePresentation   = ThemePresentation()
  let tableView           = IntrinsicTableView(frame: .zero, style: .grouped)
  let tableViewDataSource = ColorSelectionDataSource()

  let backButton = UIButton(type: .system)

  // MARK: - Init

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.startObservingColorScheme()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  private func startObservingColorScheme() {
    let notification = Notification.Name.colorSchemeDidChange
    NotificationCenter.default.addObserver(self, selector: #selector(colorSchemeDidChanged), name: notification, object: nil)
  }

  func colorSchemeDidChanged() {
    let colorScheme = Managers.theme.colorScheme
    self.view.tintColor       = colorScheme.tintColor.value
    self.backButton.tintColor = colorScheme.tintColor.value
  }

  // MARK: - Override

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.selectInitialTableViewRows()
  }

  private func selectInitialTableViewRows() {
    func selectRowAt(_ indexPath: IndexPath) {
      let animated       = false
      let scrollPosition = UITableViewScrollPosition.none

      _ = self.tableView.delegate?.tableView?(self.tableView, willSelectRowAt: indexPath)
      self.tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
      self.tableView.delegate?.tableView?(self.tableView, didSelectRowAt: indexPath)
    }

    let colorScheme = Managers.theme.colorScheme

    if let tintIndex = self.tableViewDataSource.indexOf(tintColor: colorScheme.tintColor) {
      selectRowAt(tintIndex)
    }

    if let tramIndex = self.tableViewDataSource.indexOf(tramColor: colorScheme.tramColor) {
      selectRowAt(tramIndex)
    }

    if let busIndex  = self.tableViewDataSource.indexOf(busColor: colorScheme.busColor) {
      selectRowAt(busIndex)
    }
  }

  // MARK: - Actions

  @objc func closeButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - Save

  fileprivate func saveSelectedColorScheme() {
    guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else {
      return
    }

    var tintColor: TintColor?
    var tramColor: VehicleColor?
    var busColor:  VehicleColor?

    for indexPath in selectedIndexPaths {
      let section = self.tableViewDataSource.sectionAt(indexPath.section)
      let cell    = section.cells[indexPath.row]

      switch section.type {
      case .tint: tintColor = self.readTintColor(cell)
      case .tram: tramColor = self.readVehicleColor(cell)
      case .bus:  busColor  = self.readVehicleColor(cell)
      }
    }

    if let tintColor = tintColor, let tramColor = tramColor, let busColor = busColor {
      Managers.theme.setColorScheme(tint: tintColor, tram: tramColor, bus: busColor)
    }
  }

  private func readTintColor(_ anyCell: AnyColorSelectionCellViewModel) -> TintColor {
    guard let color = anyCell.innerViewModel as? TintColor else {
      fatalError("Unexpected color")
    }
    return color
  }

  private func readVehicleColor(_ anyCell: AnyColorSelectionCellViewModel) -> VehicleColor {
    guard let color = anyCell.innerViewModel as? VehicleColor else {
      fatalError("Unexpected color")
    }
    return color
  }
}

// MARK: - UIScrollViewDelegate

extension ColorSelectionViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.updateScrollViewBackgroundColor()
  }

  private func updateScrollViewBackgroundColor() {
    let gradientColor = PresentationControllerConstants.Colors.Gradient.colors.first
    let tableColor    = Managers.theme.colorScheme.configurationBackground

    let scrollPosition  = scrollView.contentOffset.y
    let backgroundColor = scrollPosition <= 0.0 ? gradientColor : tableColor

    if let backgroundColor = backgroundColor, self.scrollView.backgroundColor != backgroundColor {
      self.scrollView.backgroundColor = backgroundColor
    }
  }
}

// MARK: - UITableViewDelegate

extension ColorSelectionViewController: UITableViewDelegate {

  // MARK: Height

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    return 50.0
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }

  // MARK: - Selection

  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    self.deselectRows(in: tableView, section: indexPath.section)
    return indexPath
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    self.saveSelectedColorScheme()
  }

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.accessoryType = .none
  }

  private func deselectRows(in tableView: UITableView, section: Int) {
    guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else {
      return
    }

    let indexPathsInSection = selectedIndexPaths.filter { $0.section == section }
    for indexPath in indexPathsInSection {
      _ = self.tableView.delegate?.tableView?(tableView, willDeselectRowAt: indexPath)
      tableView.deselectRow(at: indexPath, animated: false)
      self.tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
  }
}
