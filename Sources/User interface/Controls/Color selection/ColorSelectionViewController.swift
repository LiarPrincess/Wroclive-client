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

  let themePresentation = ThemePresentation()

  let colorsCollectionDataSource = ColorSelectionDataSource()

  lazy var colorsCollection: IntrinsicCollectionView = {
    let layout = UICollectionViewFlowLayout()
    return IntrinsicCollectionView(frame: .zero, collectionViewLayout: layout)
  }()

  // MARK: - Override

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

    let totalWidth   = self.colorsCollection.contentWidth
    let margin       = Layout.Cell.margin
    let minCellWidth = Layout.Cell.minSize

    let numSectionsThatFit = floor((totalWidth + margin) / (minCellWidth + margin))
    let cellWidth          = (totalWidth - (numSectionsThatFit - 1) * margin) / numSectionsThatFit

    self.itemSize = CGSize(width: cellWidth, height: cellWidth)
  }

  // MARK: - Actions

  @objc func closeButtonPressed() {
    self.dismiss(animated: true, completion: nil)
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

// MARK: - CollectionViewDelegateFlowLayout

extension ColorSelectionViewController: UICollectionViewDelegateFlowLayout {

  // MARK: - Size

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//    let width = self.colorsCollection.contentWidth

//    guard let sectionName = self.collectionDataSource.sectionName(at: section) else {
//      return CGSize(width: width, height: Layout.SectionHeader.fallbackHeight)
//    }
//
//    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//    let textAttributes = Managers.theme.textAttributes(for: .subheadline, alignment: .center)
//    let textSize       = sectionName.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
//
//    typealias HeaderLayout = Layout.SectionHeader
//    let topInset    = HeaderLayout.topInset
//    let bottomInset = HeaderLayout.bottomInset
//    return CGSize(width: width, height: topInset + textSize.height + bottomInset)
    return CGSize(width: 100.0, height: 50.0)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 50.0, height: 50.0) //self.itemSize
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
