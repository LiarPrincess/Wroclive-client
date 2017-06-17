//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

fileprivate typealias Constants = LineSelectionControlConstants
fileprivate typealias Layout    = Constants.Layout

class LineSelectionControl: UIViewController {
  
  //MARK: - Properties

  var selectedLines: [Line] {
    get {
      let indexPaths = self.collectionView.indexPathsForSelectedItems
      let lines = indexPaths?.map { self.collectionDataSource.line(at: $0) }.filter { $0 != nil }.map { $0! }
      return lines ?? []
    }
    set {
      for line in newValue {
        if let index = self.collectionDataSource.index(of: line) {
          self.collectionView.selectItem(at: index, animated: false, scrollPosition: [])
        }
      }
    }
  }

  //MARK: Collection

  let collectionDataSource: LineSelectionDataSource

  let collectionViewLayout = UICollectionViewFlowLayout()

  lazy var collectionView: UICollectionView = {
    return UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
  }()

  //MARK: Layout

  var contentInset = UIEdgeInsets() {
    didSet {
      if self.collectionView.contentInset != self.contentInset {
        self.collectionView.contentInset = self.contentInset
      }
    }
  }

  var scrollIndicatorInsets = UIEdgeInsets() {
    didSet {
      if self.collectionView.scrollIndicatorInsets != self.scrollIndicatorInsets {
        self.collectionView.scrollIndicatorInsets = self.scrollIndicatorInsets
      }
    }
  }

  //MARK: - Init

  init(withLines lines: [Line]) {
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

}
