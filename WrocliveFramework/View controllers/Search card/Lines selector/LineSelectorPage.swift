// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias HeaderConstants = LineSelectorConstants.Header
private typealias CellConstants = LineSelectorConstants.Cell
private typealias Localization = Localizable.Search

internal final class LineSelectorPage:
  UIViewController,
  UICollectionViewDelegate, UICollectionViewDataSource,
  UICollectionViewDelegateFlowLayout,
  LineSelectorPageType
{

  // MARK: - Properties

  private var sections = [LineSelectorSection]()
  private let viewModel: LineSelectorPageViewModel

  private lazy var collectionViewLayout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.collectionViewLayout
  )

  internal var contentInset: UIEdgeInsets {
    get { return self.collectionView.contentInset }
    set { self.collectionView.contentInset = newValue }
  }

  internal var scrollIndicatorInsets: UIEdgeInsets {
    get { return self.collectionView.scrollIndicatorInsets }
    set { self.collectionView.scrollIndicatorInsets = newValue }
  }

  internal var scrollView: UIScrollView {
    return self.collectionView
  }

  // MARK: - Init

  internal init(viewModel: LineSelectorPageViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    viewModel.setView(view: self)
  }

  internal required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ViewDidLoad

  internal override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  private func initLayout() {
    self.collectionViewLayout.minimumLineSpacing = CellConstants.margin
    self.collectionViewLayout.minimumInteritemSpacing = CellConstants.margin

    self.collectionView.registerCell(LineSelectorCell.self)
    self.collectionView.registerSupplementary(LineSelectorHeaderView.self, kind: .header)
    self.collectionView.backgroundColor         = Theme.colors.background
    self.collectionView.allowsSelection         = true
    self.collectionView.allowsMultipleSelection = true
    self.collectionView.alwaysBounceVertical    = true
    self.collectionView.delegate = self
    self.collectionView.dataSource = self

    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

  // MARK: - ViewDidLayoutSubviews

  internal override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.collectionViewLayout.itemSize = self.calculateItemSize()
  }

  private func calculateItemSize() -> CGSize {
    // number of cells:   n
    // number of margins: n-1

    // totalWidth = n * cellWidth + (n-1) * margins
    // solve for n:         n = (totalWidth + margin) / (cellWidth + margin)
    // solve for cellWidth: cellWidth = (totalWidth - (n-1) * margin) / n

    let totalWidth = self.collectionView.contentWidth
    let margin = CellConstants.margin
    let minCellWidth = CellConstants.minSize

    let cellCount = floor((totalWidth + margin) / (minCellWidth + margin))
    let cellWidth = (totalWidth - (cellCount - 1) * margin) / cellCount

    return CGSize(width: cellWidth, height: cellWidth)
  }

  // MARK: - LineSelectorPageType

  internal func refresh() {
    let sections = self.viewModel.sections
    self.setSections(sections: sections)

    let selectedLineIndices = self.viewModel.selectedLineIndices
    self.setSelectedIndices(indices: selectedLineIndices, animated: true)
  }

  internal func setSections(sections: [LineSelectorSection]) {
    if self.sections != sections {
      self.sections = sections
      self.collectionView.reloadData()
    }
  }

  internal func setSelectedIndices(indices newIndices: [IndexPath],
                                   animated: Bool) {
    let oldIndices = self.collectionView.indexPathsForSelectedItems ?? []

    let newIndicesSet = Set(newIndices)
    for index in oldIndices where !newIndicesSet.contains(index) {
      self.collectionView.deselectItem(at: index,
                                       animated: animated)
    }

    let oldIndicesSet = Set(oldIndices)
    for index in newIndices where !oldIndicesSet.contains(index) {
      self.collectionView.selectItem(at: index,
                                     animated: animated,
                                     scrollPosition: [])
    }
  }

  // MARK: - UICollectionView

  internal func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
  }

  internal func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    let section = self.sections[section]
    return section.lines.count
  }

  internal func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let section = self.sections[indexPath.section]
    let line = section.lines[indexPath.item]

    let cell = self.collectionView.dequeueCell(
      ofType: LineSelectorCell.self,
      forIndexPath: indexPath
    )

    cell.update(line: line)
    return cell
  }

  internal func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let section = self.sections[indexPath.section]

      let view = collectionView.dequeueSupplementary(
        ofType: LineSelectorHeaderView.self,
        kind: .header,
        for: indexPath
      )

      view.update(section: section)
      return view

    default:
      fatalError("[LineSelectorPage] Unexpected supplementary view: \(kind)")
    }
  }

  internal func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
    self.viewModel.viewDidSelectIndex(index: indexPath)
  }

  internal func collectionView(_ collectionView: UICollectionView,
                               didDeselectItemAt indexPath: IndexPath) {
    self.viewModel.viewDidDeselectIndex(index: indexPath)
  }

  // MARK: - CollectionViewDelegateFlowLayout

  internal func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
    let width  = self.collectionView.contentWidth
    let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)

    let section = self.sections[section]
    let text = NSAttributedString(string: section.name,
                                  attributes: HeaderConstants.textAttributes)
    let textSize = text.boundingRect(with: bounds,
                                     options: .usesLineFragmentOrigin,
                                     context: nil)

    let height = textSize.height
      + HeaderConstants.topInset
      + HeaderConstants.bottomInset
      + 1.0

    return CGSize(width: width, height: height)
  }
}
