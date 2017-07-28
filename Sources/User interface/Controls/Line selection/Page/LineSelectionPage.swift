//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

fileprivate typealias Constants = LineSelectionViewControllerConstants
fileprivate typealias Layout    = Constants.Layout

class LineSelectionPage: UIViewController {

  // MARK: - Properties

  var lines: [Line] {
    get { return self.collectionDataSource.lines }
    set { self.collectionDataSource = LineSelectionDataSource(with: newValue) }
  }

  var selectedLines: [Line] {
    get {
      return self.collectionView.indexPathsForSelectedItems?.flatMap {
        return self.collectionDataSource.line(at: $0)
      } ?? []
    }
    set {
      for line in self.lines {
        if let indexPath = self.collectionDataSource.index(of: line) {
          let isSelected = newValue.contains(line)

          if isSelected { self.collectionView.selectItem  (at: indexPath, animated: false, scrollPosition: []) }
          else          { self.collectionView.deselectItem(at: indexPath, animated: false) }
        }
      } // end for(...)
    }
  }

  // MARK: Collection

  private(set) var collectionDataSource: LineSelectionDataSource {
    didSet {
      self.collectionView.dataSource = self.collectionDataSource
      self.collectionView.reloadData()
    }
  }

  let collectionViewLayout = UICollectionViewFlowLayout()

  lazy var collectionView: UICollectionView = {
    return UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
  }()

  // MARK: Layout

  var contentInset: UIEdgeInsets {
    get { return self.collectionView.contentInset }
    set {
      if self.collectionView.contentInset != newValue {
        self.collectionView.contentInset = newValue
        self.recalculateItemSize()
      }
    }
  }

  var scrollIndicatorInsets: UIEdgeInsets {
    get { return self.collectionView.scrollIndicatorInsets }
    set {
      if self.collectionView.scrollIndicatorInsets != newValue {
        self.collectionView.scrollIndicatorInsets = newValue
      }
    }
  }

  // MARK: - Init

  init(withLines lines: [Line]) {
    self.collectionDataSource = LineSelectionDataSource(with: lines)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.recalculateItemSize()
  }

  fileprivate var itemSize = CGSize()

  private func recalculateItemSize() {
    //number of cells:   n
    //number of margins: n-1

    //totalWidth = n * cellWidth + (n-1) * margins
    //solve for n:         n = (totalWidth + margin) / (cellWidth + margin)
    //solve for cellWidth: cellWidth = (totalWidth - (n-1) * margin) / n

    let totalWidth   = self.collectionView.contentWidth
    let margin       = Layout.Cell.margin
    let minCellWidth = Layout.Cell.minSize

    let numSectionsThatFit = floor((totalWidth + margin) / (minCellWidth + margin))
    let cellWidth          = (totalWidth - (numSectionsThatFit - 1) * margin) / numSectionsThatFit

    self.itemSize = CGSize(width: cellWidth, height: cellWidth)
  }
}

// MARK: - CollectionViewDelegateFlowLayout

extension LineSelectionPage: UICollectionViewDelegateFlowLayout {

  // MARK: - Size

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let width = self.collectionView.contentWidth

    guard let sectionName = self.collectionDataSource.sectionName(at: section) else {
      return CGSize(width: width, height: Layout.SectionHeader.fallbackHeight)
    }

    let font           = Theme.current.font.subheadline
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let textSize       = sectionName.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

    typealias HeaderLayout = Layout.SectionHeader
    let topInset    = HeaderLayout.topInset
    let bottomInset = HeaderLayout.bottomInset
    return CGSize(width: width, height: topInset + textSize.height + bottomInset)
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

  // MARK: - Selection

  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

}
