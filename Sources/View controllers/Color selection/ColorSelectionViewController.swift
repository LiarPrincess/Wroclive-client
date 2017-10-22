//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Layout = ColorSelectionViewControllerConstants.Layout

protocol ColorSelectionViewControllerDelegate: class {
  func colorSelectionViewControllerDidClose(_ viewController: ColorSelectionViewController)
  func colorSelectionViewControllerDidTapCloseButton(_ viewController: ColorSelectionViewController)
}

class ColorSelectionViewController: UIViewController {

  // MARK: - Properties

  weak var delegate: ColorSelectionViewControllerDelegate?

  let scrollView        = UIScrollView()
  let scrollViewContent = UIView()

  let presentation = ColorSelectionPresentation()

  let collectionViewDataSource = ColorSelectionDataSource()
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    return IntrinsicCollectionView(frame: .zero, collectionViewLayout: layout)
  }()

  let backButton = UIButton(type: .system)

  // MARK: - Init

  convenience init(delegate: ColorSelectionViewControllerDelegate? = nil) {
    self.init(nibName: nil, bundle: nil, delegate: delegate)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, delegate: ColorSelectionViewControllerDelegate? = nil) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.delegate = delegate
    self.startObservingColorScheme()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    self.stopObservingColorScheme()
  }

  // MARK: - Override

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.recalculateItemSize()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.selectInitialColor()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.delegate?.colorSelectionViewControllerDidClose(self)
  }

  fileprivate var itemSize = CGSize()

  private func recalculateItemSize() {
    // number of cells:   n
    // number of margins: n-1

    // totalWidth = n * cellWidth + (n-1) * margins
    // solve for n:         n = (totalWidth + margin) / (cellWidth + margin)
    // solve for cellWidth: cellWidth = (totalWidth - (n-1) * margin) / n

    let totalWidth   = self.view.bounds.width - Layout.leftOffset - Layout.rightOffset
    let margin       = Layout.Cell.margin
    let minCellWidth = Layout.Cell.minSize

    let numSectionsThatFit = floor((totalWidth + margin) / (minCellWidth + margin))
    let cellWidth          = (totalWidth - (numSectionsThatFit - 1) * margin) / numSectionsThatFit

    self.itemSize = CGSize(width: cellWidth, height: cellWidth)
  }

  private func selectInitialColor() {
    func selectColorAt(_ indexPath: IndexPath) {
      self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }

    let colorScheme = Managers.theme.colors

    if let tintIndex = self.collectionViewDataSource.indexOf(tintColor: colorScheme.tintColor) {
      selectColorAt(tintIndex)
    }

    if let tramIndex = self.collectionViewDataSource.indexOf(tramColor: colorScheme.tramColor) {
      selectColorAt(tramIndex)
    }

    if let busIndex  = self.collectionViewDataSource.indexOf(busColor: colorScheme.busColor) {
      selectColorAt(busIndex)
    }
  }

  // MARK: - Actions

  @objc func closeButtonPressed() {
    self.delegate?.colorSelectionViewControllerDidTapCloseButton(self)
  }

  // MARK: - Save

  fileprivate func saveSelectedColors() {
    guard let selectedIndexPaths = self.collectionView.indexPathsForSelectedItems else {
      return
    }

    var tintColor: TintColor?
    var tramColor: VehicleColor?
    var busColor:  VehicleColor?

    for indexPath in selectedIndexPaths {
      let section = self.collectionViewDataSource.sectionAt(indexPath.section)
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

// MARK: - ColorSchemeObserver

extension ColorSelectionViewController: ColorSchemeObserver {

  func colorSchemeDidChange() {
    let colorScheme = Managers.theme.colors
    self.view.tintColor       = colorScheme.tintColor.value
    self.backButton.tintColor = colorScheme.tintColor.value
  }
}

// MARK: - UIScrollViewDelegate

extension ColorSelectionViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.updateScrollViewBackgroundColor()
  }

  private func updateScrollViewBackgroundColor() {
    let gradientColor = Managers.theme.colors.presentation.gradient.first
    let tableColor    = Managers.theme.colors.configurationBackground

    let scrollPosition  = scrollView.contentOffset.y
    let backgroundColor = scrollPosition <= 0.0 ? gradientColor : tableColor

    if let backgroundColor = backgroundColor, self.scrollView.backgroundColor != backgroundColor {
      self.scrollView.backgroundColor = backgroundColor
    }
  }
}

// MARK: - CollectionViewDelegateFlowLayout

extension ColorSelectionViewController: UICollectionViewDelegateFlowLayout {

  // MARK: - Size

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let width = self.collectionView.contentWidth

    let sectionName = self.collectionViewDataSource.sectionAt(section).name

    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let textAttributes = Managers.theme.textAttributes(for: .caption)
    let textSize       = sectionName.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)

    typealias HeaderLayout = Layout.Section.Header
    let topInset    = HeaderLayout.topInset
    let bottomInset = HeaderLayout.bottomInset
    return CGSize(width: width, height: topInset + textSize.height + bottomInset + 1.0)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    let width  = self.collectionView.contentWidth
    let height = Layout.Section.Footer.height
    return CGSize(width: width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return self.itemSize
  }

  // MARK: - Margin

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Layout.Cell.margin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Layout.Cell.margin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: Layout.Section.topInset, left: Layout.leftOffset, bottom: Layout.Section.bottomInset, right: Layout.rightOffset)
  }

  // MARK: - Selection

  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
    return false
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.deselectCells(in: collectionView, section: indexPath.section, except: indexPath.row)
    self.saveSelectedColors()
  }

  private func deselectCells(in collectionView: UICollectionView, section: Int, except cell: Int) {
    guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else {
      return
    }

    for indexPath in selectedIndexPaths {
      if indexPath.section == section && indexPath.row != cell {
        collectionView.deselectItem(at: indexPath, animated: false)
      }
    }
  }
}
