//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = LineSelectionViewControllerConstants

//MARK: - LineSelectionViewController

class LineSelectionViewController: UIViewController {

  //MARK: - Properties

  let navigationBarBlur = UIBlurEffect(style: .extraLight)

  lazy var navigationBarBlurView: UIVisualEffectView =  {
    return UIVisualEffectView(effect: self.navigationBarBlur)
  }()

  let navigationBar    = UINavigationBar()
  let saveButton       = UIBarButtonItem()
  let searchButton     = UIBarButtonItem()
  let lineTypeSelector = UISegmentedControl()

  let lineCollectionLayout = UICollectionViewFlowLayout()

  lazy var lineCollection: UICollectionView = {
    return UICollectionView(frame: CGRect.zero, collectionViewLayout: self.lineCollectionLayout)
  }()

  let tramsDataSource = LineSelectionDataSource()
  let busesDataSource = LineSelectionDataSource()

  struct LineTypeIndex {
    static let tram = 0
    static let bus  = 1
  }

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initDataSource()
    self.initLayout()
    self.updateLineCollectionDataSource()
  }

  private func initDataSource() {
    let lines = LinesManager.instance.getLines()
    self.tramsDataSource.lines = lines.filter { $0.type == .tram }
    self.busesDataSource.lines = lines.filter { $0.type == .bus }
  }

  //MARK: - Actions

  @objc func saveButtonPressed() {
    logger.info("saveButtonPressed")
  }

  @objc func searchButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }

  @objc func lineTypeChanged() {
    self.updateLineCollectionDataSource()
  }

  //MARK: - Methods

  private func updateLineCollectionDataSource() {
    let selectedIndex = self.lineTypeSelector.selectedSegmentIndex
    let dataSource    = selectedIndex == LineTypeIndex.tram ? self.tramsDataSource : self.busesDataSource

    self.lineCollection.dataSource = dataSource
  }
}

//MARK: - CardPanelPresentable

extension LineSelectionViewController : CardPanelPresentable {
  var contentView:       UIView { return self.view }
  var interactionTarget: UIView { return self.navigationBarBlurView }
}

//MARK: - CollectionViewDelegateFlowLayout

extension LineSelectionViewController: UICollectionViewDelegateFlowLayout {

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

}
