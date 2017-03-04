//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

fileprivate struct LineSelectionConstants {
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

fileprivate struct LineSelectionSection {
  let vehicleType: VehicleType
  var lineNames: [String]
}

class LineSelectionViewController: UIViewController {

  //MARK: - Static

  static let identifier = "LineSelectionViewController"

  //MARK: - Properties

  fileprivate var sections: [LineSelectionSection]?

  @IBOutlet weak var collectionView: UICollectionView!

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.dataSource = self
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

  //MARK: - Methods

  fileprivate func sectionFor() {

  }

}

//MARK: - StoreSubscriber

extension LineSelectionViewController: StoreSubscriber {

  func newState(state: LineSelectionState) {
    guard state.visible else {
      self.dismiss(animated: true, completion: nil)
      return
    }

    if self.sections == nil {
      self.sections = createSections(from: state.availableLines)
      self.collectionView.reloadData()
    }
  }

  private func createSections(from lines: [Line]) -> [LineSelectionSection] {
    var groupedLines = [LineSelectionSection]()
    for line in lines {
      if let index = groupedLines.index(where: { $0.vehicleType == line.type }) {
        groupedLines[index].lineNames.append(line.name)
      }
      else {
        groupedLines.append(LineSelectionSection(vehicleType: line.type, lineNames: [line.name]))
      }
    }

//    var result = [LineSelectionSection]()
//    for section in groupedLines.sorted(by: { $0.vehicleType.rawValue < $1.vehicleType.rawValue }) {
//      let sortedLines = section.lineNames.sorted()
//      result.append(LineSelectionSection(vehicleType: section.vehicleType, lineNames: sortedLines))
//    }

    return groupedLines
  }

}

extension LineSelectionViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.sections == nil ? 0 : self.sections![section].lineNames.count
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LineSelectionConstants.headerCellIdentifier, for: indexPath) as! LineSelectionHeaderCell

      let section = self.sections![indexPath.section]
      headerCell.label.text = section.vehicleType.description

      self.customizeAppearance(headerCell)
      return headerCell

    default:
      fatalError("Unexpected element kind in LineSelectionViewController")
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LineSelectionConstants.cellIdentifier, for: indexPath) as! LineSelectionCell

    self.customizeAppearance(cell)

    let lineName = self.sections![indexPath.section].lineNames[indexPath.row]
    cell.label.text = lineName

    return cell
  }

  //MARK: - Methods

  private func customizeAppearance(_ header: LineSelectionHeaderCell) {
    header.label.font = UIFont.customPreferredFont(forTextStyle: .headline)
  }

  private func customizeAppearance(_ cell: LineSelectionCell) {
    cell.label.font = UIFont.customPreferredFont(forTextStyle: .body)
    cell.label.textColor = self.view.tintColor

    //add rounded border
    cell.label.layer.cornerRadius = LineSelectionConstants.Cell.cornerRadius
    cell.label.layer.borderWidth = 1.0
    cell.label.layer.borderColor = self.view.tintColor.cgColor
    cell.label.clipsToBounds = true
  }
}

extension LineSelectionViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: LineSelectionConstants.Cell.width, height: LineSelectionConstants.Cell.height)
  }

  //MARK: - Section spacing

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: LineSelectionConstants.SectionHeader.width, height: LineSelectionConstants.SectionHeader.height)
  }

  //MARK: - Item spacing

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return LineSelectionConstants.Cell.minHorizontalMargin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return LineSelectionConstants.Cell.minVerticalMargin
  }

}
