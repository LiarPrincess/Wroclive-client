//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = SearchViewControllerConstants

class SearchViewController: UIViewController {

  //MARK: - Properties

  let navigationBarBlur = UIBlurEffect(style: .extraLight)

  lazy var navigationBarBlurView: UIVisualEffectView =  {
    return UIVisualEffectView(effect: self.navigationBarBlur)
  }()

  let navigationBar    = UINavigationBar()
  let saveButton       = UIBarButtonItem()
  let searchButton     = UIBarButtonItem()

  //MARK: Line type

  let lineTypeSelector = UISegmentedControl()

  struct LineTypeIndex {
    static let tram = 0
    static let bus  = 1
  }

  //MARK: Tram

  let tramDataSource       = LineSelectionDataSource()
  let tramCollectionLayout = UICollectionViewFlowLayout()

  lazy var tramCollection: UICollectionView = {
    return UICollectionView(frame: CGRect.zero, collectionViewLayout: self.tramCollectionLayout)
  }()

  //MARK: Bus

  let busDataSource       = LineSelectionDataSource()
  let busCollectionLayout = UICollectionViewFlowLayout()

  lazy var busCollection: UICollectionView = {
    return UICollectionView(frame: CGRect.zero, collectionViewLayout: self.busCollectionLayout)
  }()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initDataSource()
    self.initLayout()
    self.updateLineCollectionVisibility()
  }

  //MARK: - Actions

  @objc func saveButtonPressed() {
    logger.info("saveButtonPressed")
  }

  @objc func searchButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }

  @objc func lineTypeChanged() {
    self.updateLineCollectionVisibility()
  }

  //MARK: - Methods

  private func initDataSource() {
    let lines = LinesManager.instance.getLines()
    self.tramDataSource.lines = lines.filter { $0.type == .tram }
    self.busDataSource.lines  = lines.filter { $0.type == .bus }
  }

  private func updateLineCollectionVisibility() {
    let selectedIndex = self.lineTypeSelector.selectedSegmentIndex
    self.tramCollection.isHidden = selectedIndex != LineTypeIndex.tram
    self.busCollection.isHidden  = selectedIndex != LineTypeIndex.bus
  }
}

//MARK: - CardPanelPresentable

extension SearchViewController : CardPanelPresentable {
  var contentView:       UIView { return self.view }
  var interactionTarget: UIView { return self.navigationBarBlurView }
}

//MARK: - CollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {

  //MARK: - Size

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: Constants.Layout.LineCollection.Section.headerHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    typealias CellConstants = Constants.Layout.LineCollection.Cell
    return CGSize(width: CellConstants.width, height: CellConstants.height)
  }

  //MARK: - Margin

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Constants.Layout.LineCollection.Cell.minMargin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Constants.Layout.LineCollection.Cell.minMargin
  }

  //MARK: - Content placement

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    typealias sectionConstants = Constants.Layout.LineCollection.Section

    let isLastSection = section == (collectionView.numberOfSections - 1)
    return isLastSection ? sectionConstants.lastSectionInsets : sectionConstants.insets
  }

  //MARK: - Selection

  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    logger.info("didSelectItemAt: \(indexPath)")
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    logger.info("didDeselectItemAt: \(indexPath)")
  }

}
