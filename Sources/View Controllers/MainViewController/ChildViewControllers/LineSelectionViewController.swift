//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

struct LineSelectionViewControllerConstants {
  static let cellIdentifier = "LineSelectionCell"
  static let headerCellIdentifier = "LineSelectionHeaderCell"

  struct SectionHeader {
    static let width: CGFloat = 0.0
    static let height: CGFloat = 40.0
  }

  struct Cell {
    static let width: CGFloat = 44.0
    static let height: CGFloat = 30.0

    static let cornerRadius: CGFloat = 2.0

    static let minVerticalMargin: CGFloat = 5.0
    static let minHorizontalMargin: CGFloat = 5.0
  }
}

class LineSelectionViewController: UIViewController {

  //MARK: - Static

  static let identifier = "LineSelectionViewController"

  //MARK: - Properties

  fileprivate var dataSource = LineSelectionDataSource()

  @IBOutlet weak var collectionView: UICollectionView!

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
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

    cell.label.font = UIFont.customPreferredFont(forTextStyle: .body)
    cell.label.textColor = self.view.tintColor

    //round corners
    cell.label.layer.cornerRadius = LineSelectionViewControllerConstants.Cell.cornerRadius
    cell.label.layer.borderWidth = 1.0
    cell.label.layer.borderColor = self.view.tintColor.cgColor
    cell.label.clipsToBounds = true
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: LineSelectionViewControllerConstants.Cell.width, height: LineSelectionViewControllerConstants.Cell.height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return LineSelectionViewControllerConstants.Cell.minHorizontalMargin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return LineSelectionViewControllerConstants.Cell.minVerticalMargin
  }
  
}
