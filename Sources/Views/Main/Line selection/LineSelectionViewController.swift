//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit

fileprivate typealias Constants = LineSelectionViewControllerConstants

//MARK: - LineSelectionViewController

class LineSelectionViewController: UIViewController {

  //MARK: - Properties

  let navigationBar = UINavigationBar()
  let saveButton    = UIBarButtonItem()
  let searchButton  = UIBarButtonItem()

  let lineTypeSelector = UISegmentedControl()
  let lineCollection   = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

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
  var interactionTarget: UIView { return self.navigationBar }
}

//MARK: - CollectionViewDelegateFlowLayout

extension LineSelectionViewController: UICollectionViewDelegateFlowLayout {

  //MARK: - Size

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: Constants.Layout.CellHeader.height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //number of cells:   n
    //number of margins: (n-1)

    //totalWidth = n * cellWidth + (n-1) * margins
    //-> n = (totalWidth + margin) / (cellWidth + margin)
    //-> cellWidth = (totalWidth - (n-1) * margin) / n

    let totalWidth   = collectionView.bounds.width
    let margin       = Constants.Layout.Cell.margin
    let minCellWidth = Constants.Layout.Cell.minWidth

    let numSectionsThatFit = floor((totalWidth + margin) / (minCellWidth + margin))
    let cellWidth          = (totalWidth - (numSectionsThatFit - 1) * margin) / numSectionsThatFit

    let goldenRatio: CGFloat = 1.6180
    return CGSize(width: floor(cellWidth), height: floor(cellWidth / goldenRatio))
  }

  //MARK: - Margin

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Constants.Layout.Cell.margin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Constants.Layout.Cell.margin
  }

  //MARK: - Content placement

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let leftOffset  = Constants.Layout.Content.leftOffset
    let rightOffset = Constants.Layout.Content.rightOffset
    return UIEdgeInsets(top: 0.0, left: leftOffset, bottom: 0.0, right: rightOffset)
  }

}

//MARK: - UI Init

extension LineSelectionViewController {

  fileprivate func initLayout() {
    self.view.backgroundColor = UIColor.white
    self.initNavigationBar()
    self.initLineTypeSelector()
    self.initLinesCollection()
  }

  private func initNavigationBar() {
    self.view.addSubview(self.navigationBar)

    navigationBar.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview()
    }

    self.navigationItem.title = "Select lines"
    self.navigationBar.pushItem(navigationItem, animated: false)

    self.saveButton.style  = .plain
    self.saveButton.title  = "Save"
    self.saveButton.target = self
    self.saveButton.action = #selector(saveButtonPressed)

    self.searchButton.style  = .plain
    self.searchButton.title  = "Search"
    self.searchButton.target = self
    self.searchButton.action = #selector(searchButtonPressed)

    self.navigationItem.setLeftBarButton(self.saveButton, animated: false)
    self.navigationItem.setRightBarButton(self.searchButton, animated: false)
  }

  private func initLineTypeSelector() {
    self.lineTypeSelector.insertSegment(withTitle: "Trams", at: Constants.LineTypeIndex.tram, animated: false)
    self.lineTypeSelector.insertSegment(withTitle: "Buses", at: Constants.LineTypeIndex.bus, animated: false)
    self.lineTypeSelector.selectedSegmentIndex = Constants.LineTypeIndex.tram

    self.lineTypeSelector.addTarget(self, action: #selector(lineTypeChanged), for: .valueChanged)
    self.lineTypeSelector.font = FontManager.instance.lineSelectionLineTypeSelector
    self.view.addSubview(self.lineTypeSelector)

    self.lineTypeSelector.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBar.snp.bottom).offset(Constants.Layout.LineTypeSelector.topOffset)
      make.left.equalToSuperview().offset(Constants.Layout.Content.leftOffset)
      make.right.equalToSuperview().offset(-Constants.Layout.Content.rightOffset)
    }
  }

  private func initLinesCollection() {
    self.lineCollection.register(LineSelectionCell.self)
    self.lineCollection.register(LineSelectionCellHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "LineSelectionCellHeader")
    self.lineCollection.backgroundColor = UIColor.white
    self.lineCollection.allowsSelection = true
    self.lineCollection.allowsMultipleSelection = true
    //self.lineCollection.dataSource will be set later in self.updateLineCollectionDataSource()
    self.lineCollection.delegate = self

    self.view.addSubview(self.lineCollection)

    self.lineCollection.snp.makeConstraints { make in
      make.top.equalTo(self.lineTypeSelector.snp.bottom).offset(Constants.Layout.LineCollection.topOffset)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview().offset(-Constants.Layout.LineCollection.bottomOffset)
    }
  }

}
