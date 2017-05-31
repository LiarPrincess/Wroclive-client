//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import Foundation
import ReSwift

struct LineSelectionViewControllerConstants {
  struct CellIdentifiers {
    static let line = "LineSelection_Line"
  }
  
  struct Cell {
    static let minCellWidth: CGFloat = 50.0
    static let margin: CGFloat = 5.0
    static let cornerRadius: CGFloat = 4.0
  }
}

class LineSelectionViewController: UIViewController {

  //MARK: - Static

  static let identifier = "LineSelectionViewController"

  //MARK: - Properties

  fileprivate var dataSource = LineSelectionDataSource()

  var vehicleType: VehicleType {
    get { return self.vehicleTypeSelection.selectedSegmentIndex == 0 ? .tram : .bus }
    set { self.vehicleTypeSelection.selectedSegmentIndex = newValue == .tram ? 0 : 1 }
  }

  @IBOutlet weak var vehicleTypeSelection: UISegmentedControl!
  @IBOutlet weak var collectionView: UICollectionView!

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.customizeAppearance()

    self.collectionView.dataSource = self.dataSource
    self.collectionView.delegate = self

    //we need to 'subscribe' in 'viewDidLoad' as interaction controller will call 'viewWillAppear' multiple times
    store.subscribe(self, selector: { $0.lineSelectionState })
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    //we need to 'unsubscribe' in 'viewDidDisappear' as interaction controller will call 'viewWillDisappear' even when gesture was cancelled
    store.dispatch(SetLineSelectionVisibility(false))
    store.unsubscribe(self)
  }

  //MARK: - Actions

  @IBAction func doneButtonPressed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

  @IBAction func vehicleTypeFilterChanged(_ sender: Any) {
    store.dispatch(SetLineSelectionFilter(self.vehicleType))
  }

  //MARK: - Methods

  fileprivate func customizeAppearance() {
    self.vehicleTypeSelection.font = UIFont.customPreferredFont(forTextStyle: .body)
  }

}

//MARK: - StoreSubscriber

extension LineSelectionViewController: StoreSubscriber {

  func newState(state: LineSelectionState) {
    guard state.visible else {
      return
    }

    //data source

    var shouldReloadData = false

    if self.dataSource.availableLines != state.availableLines {
      self.dataSource.availableLines = state.availableLines
      shouldReloadData = true
    }

    if self.dataSource.vehicleTypeFilter != state.vehicleTypeFilter {
      if self.vehicleType != state.vehicleTypeFilter {
        self.vehicleType = state.vehicleTypeFilter
      }

      self.dataSource.vehicleTypeFilter = state.vehicleTypeFilter
      shouldReloadData = true
    }

    if shouldReloadData {
      self.collectionView.reloadData()
    }
  }

}

//MARK: - CollectionViewDelegateFlowLayout

extension LineSelectionViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let cell = cell as? LineSelectionCell else {
      fatalError("Invalid cell type passed to '\(#function)'")
    }

    cell.label.textColor = self.view.tintColor

    //round corners
    cell.label.layer.cornerRadius = LineSelectionViewControllerConstants.Cell.cornerRadius
    cell.label.layer.borderWidth = 1.0
    cell.label.layer.borderColor = self.view.tintColor.cgColor
    cell.label.clipsToBounds = true
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //number of sections: n
    //number of margins: (n-1)

    //totalWidth = n * cellWidth + (n-1) * margins
    //-> n = (totalWidth + margin) / (cellWidth + margin)
    //-> cellWidth = (totalWidth - (n-1) * margin) / n

    let totalWidth = collectionView.bounds.width
    let margin = LineSelectionViewControllerConstants.Cell.margin
    let minCellWidth = LineSelectionViewControllerConstants.Cell.minCellWidth

    let numSectionsThatFit = floor((totalWidth + margin) / (minCellWidth + margin))
    let cellWidth = (totalWidth - (numSectionsThatFit - 1) * margin) / numSectionsThatFit

    let goldenRatio: CGFloat = 1.6180
    return CGSize(width: floor(cellWidth), height: floor(cellWidth / goldenRatio))
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return LineSelectionViewControllerConstants.Cell.margin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return LineSelectionViewControllerConstants.Cell.margin
  }
  
}
