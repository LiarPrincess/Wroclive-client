//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class ColorSelectionViewController: UIViewController {

  // MARK: - Properties

  let scrollView        = UIScrollView()
  let scrollViewContent = UIView()

  let themePresentation = ThemePresentation()

  lazy var colorsCollection: IntrinsicCollectionView = {
    let layout = UICollectionViewFlowLayout()
    return IntrinsicCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
  }()

  // MARK: - Override

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
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

//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//    let width = self.colorsCollection.contentWidth
//
////    guard let sectionName = self.collectionDataSource.sectionName(at: section) else {
////      return CGSize(width: width, height: Layout.SectionHeader.fallbackHeight)
////    }
////
////    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
////    let textAttributes = Managers.theme.textAttributes(for: .subheadline, alignment: .center)
////    let textSize       = sectionName.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
////
////    typealias HeaderLayout = Layout.SectionHeader
////    let topInset    = HeaderLayout.topInset
////    let bottomInset = HeaderLayout.bottomInset
////    return CGSize(width: width, height: topInset + textSize.height + bottomInset)
//    return CGSize(width: width, height: 40.0)
//  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return self.itemSize
    return CGSize(width: 42.0, height: 42.0)
  }

  // MARK: - Margin

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//    return Layout.Cell.margin
    return 2.0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//    return Layout.Cell.margin
    return 2.0
  }

  // MARK: - Selection

  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
    return true
  }
}

// MARK: - UICollectionViewDataSource

extension ColorSelectionViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1 //self.viewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 50 //self.viewModels[section].lines.count
  }

//  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//    switch kind {
//    case UICollectionElementKindSectionHeader:
//      let view      = collectionView.dequeueReusableSupplementaryView(ofType: LineSelectionSectionHeaderView.self, kind: kind, for: indexPath)
//      let viewModel = self.viewModels[indexPath.section]
//
//      view.setUp(with: viewModel)
//      return view
//
//    default:
//      fatalError("Unexpected element kind")
//    }
//  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(ofType: LineSelectionCell.self, forIndexPath: indexPath)
//    let viewModel = self.viewModels[indexPath.section].lineViewModels[indexPath.row]
//
//    cell.setUp(with: viewModel)
//    return cell
    let cell = self.colorsCollection.dequeueReusableCell(ofType: UICollectionViewCell.self, forIndexPath: indexPath)
    cell.backgroundColor = UIColor.red
    return cell
  }
}
