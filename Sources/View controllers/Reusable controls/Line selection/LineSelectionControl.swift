//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

fileprivate typealias Constants = LineSelectionControlConstants
fileprivate typealias Layout    = Constants.Layout

class LineSelectionControl: UIViewController {
  
  //MARK: - Properties

  weak var delegate: LineSelectionControlDelegate?

  let collectionDataSource: LineSelectionDataSource

  let collectionViewLayout = UICollectionViewFlowLayout()

  lazy var collectionView: UICollectionView = {
    return UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
  }()

  var leftSectionInset:  CGFloat = 0
  var rightSectionInset: CGFloat = 0

  //MARK: - Init

  init(withLines lines: [Line], delegate: LineSelectionControlDelegate? = nil) {
    self.collectionDataSource = LineSelectionDataSource(with: lines)
    self.delegate             = delegate
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  //MARK: - Delegate

  fileprivate func delegateDidSelect(_ line: Line) {
    self.delegate?.lineSelectionControl(self, didSelect: line)
  }

  fileprivate func delegateDidDeselect(_ line: Line) {
    self.delegate?.lineSelectionControl(self, didDeselect: line)
  }

  //MARK: - Methods

  func select(line: Line) {
    if let index = self.collectionDataSource.index(of: line) {
      self.collectionView.selectItem(at: index, animated: false, scrollPosition: .centeredHorizontally)
      self.delegateDidSelect(line)
    }
  }

}

//MARK: - CollectionViewDelegateFlowLayout

extension LineSelectionControl: UICollectionViewDelegateFlowLayout {

  //MARK: - Size

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: Layout.Section.headerHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: Layout.Cell.width, height: Layout.Cell.height)
  }

  //MARK: - Margin

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Layout.Cell.minMargin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Layout.Cell.minMargin
  }

  //MARK: - Content placement

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let isLastSection = section == (collectionView.numberOfSections - 1)
    var inset = isLastSection ? Layout.Section.lastSectionInsets : Layout.Section.insets
    inset.left  += self.leftSectionInset
    inset.right += self.rightSectionInset
    return inset
  }

  //MARK: - Selection

  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let lineSelectionDataSource = collectionView.dataSource as? LineSelectionDataSource {
      if let line = lineSelectionDataSource.line(at: indexPath) {
        self.delegateDidSelect(line)
      }
    }
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if let lineSelectionDataSource = collectionView.dataSource as? LineSelectionDataSource {
      if let line = lineSelectionDataSource.line(at: indexPath) {
        self.delegateDidDeselect(line)
      }
    }
  }
  
}
