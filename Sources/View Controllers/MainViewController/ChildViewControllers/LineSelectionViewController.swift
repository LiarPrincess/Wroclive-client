//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

struct LineSelectionViewControllerConstants {
  static let cellIdentifier = "LineSelectionCell"
  static let headerCellIdentifier = "LineSelectionHeaderCell"

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

  @IBOutlet weak var vehicleTypeSelection: UISegmentedControl!
  @IBOutlet weak var collectionView: UICollectionView!

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.customizeAppearance()
    self.collectionView.dataSource = self.dataSource
    self.collectionView.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    store.subscribe(self) { state in state.lineSelectionState }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    store.unsubscribe(self)
  }

  //MARK: - Actions

  @IBAction func doneButtonPressed(_ sender: Any) {
    store.dispatch(SetLineSelectionVisibility(false))
  }

  @IBAction func vehicleTypeChanged(_ sender: Any) {
    let selected = self.vehicleTypeSelection.selectedSegmentIndex
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
      self.dismiss(animated: true, completion: nil)
      return
    }

    if self.dataSource.availableLines != state.availableLines {
      self.dataSource.availableLines = state.availableLines
    }
  }
}

//MARK: - CollectionViewDelegateFlowLayout

extension LineSelectionViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let cell = cell as? LineSelectionCell else {
      fatalError("Invalid cell type passed to LineSelectionViewController.UICollectionViewDelegateFlowLayout")
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

    let numSections = floor((totalWidth + margin) / (minCellWidth + margin))
    let width = (totalWidth - (numSections - 1) * margin) / numSections

    let goldenRatio: CGFloat = 1.6180
    return CGSize(width: floor(width), height: floor(width / goldenRatio))
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return LineSelectionViewControllerConstants.Cell.margin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return LineSelectionViewControllerConstants.Cell.margin
  }
  
}
