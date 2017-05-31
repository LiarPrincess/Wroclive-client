//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
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

  @objc fileprivate func saveButtonPressed() {
    logger.info("saveButtonPressed")
  }

  @objc fileprivate func searchButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }

  @objc fileprivate func lineTypeChanged() {
    self.updateLineCollectionDataSource()
  }

  //MARK: - Methods

  private func updateLineCollectionDataSource() {
    let selectedIndex = self.lineTypeSelector.selectedSegmentIndex
    let dataSource    = selectedIndex == Constants.LineTypeIndex.tram ? self.tramsDataSource : self.busesDataSource

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
    //number of cells:   n
    //number of margins: (n-1)

    //totalWidth = n * cellWidth + (n-1) * margins
    //-> n = (totalWidth + margin) / (cellWidth + margin)
    //-> cellWidth = (totalWidth - (n-1) * margin) / n

    let totalWidth   = collectionView.bounds.width
    let margin       = Constants.Layout.LineCollection.Cell.margin
    let minCellWidth = Constants.Layout.LineCollection.Cell.minWidth

    let numSectionsThatFit = floor((totalWidth + margin) / (minCellWidth + margin))
    let cellWidth          = (totalWidth - (numSectionsThatFit - 1) * margin) / numSectionsThatFit

    let goldenRatio: CGFloat = 1.6180
    return CGSize(width: floor(cellWidth), height: floor(cellWidth / goldenRatio))
  }

  //MARK: - Margin

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Constants.Layout.LineCollection.Cell.margin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Constants.Layout.LineCollection.Cell.margin
  }

  //MARK: - Content placement

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    typealias sectionConstants = Constants.Layout.LineCollection.Section

    let isLastSection = section == (collectionView.numberOfSections - 1)
    return isLastSection ? sectionConstants.lastSectionInsets : sectionConstants.insets
  }

}

//MARK: - UI Init

extension LineSelectionViewController {

  private typealias Layout = Constants.Layout

  fileprivate func initLayout() {
    self.view.backgroundColor = UIColor.white
    self.initNavigationBar()
    self.initLinesCollection()
  }

  private func initNavigationBar() {
    self.navigationBarBlurView.addBorder(at: .bottom)
    self.view.addSubview(self.navigationBarBlurView)

    self.navigationBarBlurView.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview()
    }

    // remove background, so that blur view view can be seen
    // see: https://developer.apple.com/library/content/samplecode/NavBar/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007418-Intro-DontLinkElementID_2
    self.initNavigationBarItem()
    self.navigationBar.shadowImage = UIImage()
    self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationBarBlurView.addSubview(self.navigationBar)

    self.navigationBar.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview()
    }

    self.initLineTypeSelector()
    self.navigationBarBlurView.addSubview(self.lineTypeSelector)

    self.lineTypeSelector.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBar.snp.bottom).offset(Layout.LineTypeSelector.topOffset)
      make.left.equalToSuperview().offset(Layout.Content.leftOffset)
      make.right.equalToSuperview().offset(-Layout.Content.rightOffset)
      make.bottom.equalTo(self.navigationBarBlurView.snp.bottom).offset(-Layout.LineTypeSelector.bottomOffset)
    }
  }

  private func initNavigationBarItem() {
    self.navigationItem.title = "Select lines"
    self.navigationBar.pushItem(navigationItem, animated: false)

    self.saveButton.style  = .plain
    self.saveButton.title  = "Save"
    self.saveButton.target = self
    self.saveButton.action = #selector(saveButtonPressed)
    self.navigationItem.setLeftBarButton(self.saveButton, animated: false)

    self.searchButton.style  = .plain
    self.searchButton.title  = "Search"
    self.searchButton.target = self
    self.searchButton.action = #selector(searchButtonPressed)
    self.navigationItem.setRightBarButton(self.searchButton, animated: false)
  }

  private func initLineTypeSelector() {
    self.lineTypeSelector.insertSegment(withTitle: "Trams", at: Constants.LineTypeIndex.tram, animated: false)
    self.lineTypeSelector.insertSegment(withTitle: "Buses", at: Constants.LineTypeIndex.bus, animated: false)
    self.lineTypeSelector.selectedSegmentIndex = Constants.LineTypeIndex.tram

    self.lineTypeSelector.addTarget(self, action: #selector(lineTypeChanged), for: .valueChanged)
    self.lineTypeSelector.font = FontManager.instance.lineSelectionLineTypeSelector
  }

  private func initLinesCollection() {
    self.lineCollection.register(LineSelectionCell.self)
    self.lineCollection.registerSupplementary(LineSelectionSectionHeaderView.self, ofKind: UICollectionElementKindSectionHeader)
    self.lineCollection.backgroundColor = UIColor.white
    self.lineCollection.allowsSelection = true
    self.lineCollection.allowsMultipleSelection = true
    //self.lineCollection.dataSource will be set later in self.updateLineCollectionDataSource()
    self.lineCollection.delegate = self

    self.view.addSubview(self.lineCollection)
    self.view.sendSubview(toBack: self.lineCollection)

    self.lineCollection.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBarBlurView.snp.bottom)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

}
