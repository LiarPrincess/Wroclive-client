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

  let lines:                          [Line]
  fileprivate(set) var selectedLines: [Line]

  //MARK: Collection

  let collectionDataSource: LineSelectionDataSource

  let collectionViewLayout = UICollectionViewFlowLayout()

  lazy var collectionView: UICollectionView = {
    return UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
  }()

  //MARK: Layout

  var contentInset: UIEdgeInsets {
    get { return self.collectionView.contentInset }
    set {
      if self.collectionView.contentInset != newValue {
        self.collectionView.contentInset = newValue
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

  //MARK: - Init

  init(withLines lines: [Line], selected selectedLines: [Line], delegate: LineSelectionControlDelegate? = nil) {
    let isSelectedSubsetOfLines = lines.containsAll(other: selectedLines)
    guard isSelectedSubsetOfLines else {
      fatalError("Selected lines should be a subset of lines")
    }

    self.delegate = delegate

    self.lines                = lines
    self.selectedLines        = selectedLines
    self.collectionDataSource = LineSelectionDataSource(with: lines)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
    self.refreshCollectionSelectedItems(animated: false)
  }

  //MARK: - Methods

  private func refreshCollectionSelectedItems(animated: Bool) {
    for line in self.lines {
      if let indexPath = self.collectionDataSource.index(of: line) {
        let isSelected = self.selectedLines.contains(line)

        if isSelected {
          self.collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: [])
        }
        else {
          self.collectionView.deselectItem(at: indexPath, animated: animated)
        }
      }
    }
  }

  //MARK: Delegate

  fileprivate func delegateDidSelect(line: Line) {
    self.delegate?.control(self, didSelect: line)
  }

  fileprivate func delegateDidDeselect(line: Line) {
    self.delegate?.control(self, didDeselect: line)
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
    return Layout.Section.insets
  }

  //MARK: - Selection

  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let line = self.collectionDataSource.line(at: indexPath) {
      self.selectedLines.append(line)
      self.delegateDidSelect(line: line)
    }
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if let line  = self.collectionDataSource.line(at: indexPath), let index = self.selectedLines.index(of: line) {
      self.selectedLines.remove(at: index)
      self.delegateDidDeselect(line: line)
    }
  }

}
