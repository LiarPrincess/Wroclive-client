//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = SearchViewControllerConstants
fileprivate typealias Layout    = Constants.Layout

class SearchViewController: UIViewController {

  //MARK: - Properties

  var selectedLines: [Line] {
    get {
      let selectedTrams = self.tramSelectionControl.selectedLines
      let selectedBuses = self.busSelectionControl.selectedLines
      return selectedTrams + selectedBuses
    }
    set {
      self.tramSelectionControl.selectedLines = newValue.filter { $0.type == .tram }
      self.busSelectionControl.selectedLines  = newValue.filter { $0.type == .bus }
    }
  }

  //MARK: Layout


  let headerViewBlur = UIBlurEffect(style: .extraLight)

  lazy var headerView: UIVisualEffectView =  {
    return UIVisualEffectView(effect: self.headerViewBlur)
  }()

  let cardTitle    = UILabel()
  let saveButton   = UIButton()
  let searchButton = UIButton()
  
  let lineTypeSelector = UISegmentedControl()

  var tramSelectionControl: LineSelectionControl!
  var busSelectionControl:  LineSelectionControl!

  struct LineTypeIndex {
    static let tram = 0
    static let bus  = 1
  }

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLineSelectionControls()
    self.initLayout()
    self.restoreState()
    self.showCollectionViewFromSelector()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetCollectionViewsBelowHeaderView()
  }

  override func viewWillDisappear(_ animated: Bool) {
    self.saveState()
  }

  //MARK: - Actions

  @objc func saveButtonPressed() {
    let alertController = SaveBookmarkAlert.create(forSaving: self.selectedLines)
    self.present(alertController, animated: true, completion: nil)
  }

  @objc func searchButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }

  @objc func lineTypeChanged() {
    self.showCollectionViewFromSelector()
  }

  //MARK: - Methods

  private func initLineSelectionControls() {
    let lines = LinesManager.instance.getLines()
    self.tramSelectionControl = LineSelectionControl(withLines: lines.filter { $0.type == .tram })
    self.busSelectionControl  = LineSelectionControl(withLines: lines.filter { $0.type == .bus })
  }

  private func showCollectionViewFromSelector() {
    let selectedIndex = self.lineTypeSelector.selectedSegmentIndex
    self.tramSelectionControl.view.isHidden = selectedIndex != LineTypeIndex.tram
    self.busSelectionControl.view.isHidden  = selectedIndex != LineTypeIndex.bus
  }

  private func insetCollectionViewsBelowHeaderView() {
    func fixInsets(in lineSelection: LineSelectionControl) {
      let currentInset = lineSelection.contentInset
      let headerHeight = self.headerView.bounds.height

      if currentInset.top < headerHeight {
        let topOffset   = headerHeight
        let leftOffset  = Layout.leftOffset
        let rightOffset = Layout.rightOffset
        let bottomInset = Layout.bottomOffset

        let contentInset          = UIEdgeInsets(top: topOffset, left: leftOffset, bottom: bottomInset, right: rightOffset)
        let scrollIndicatorInsets = UIEdgeInsets(top: topOffset, left: 0.0,        bottom: 0.0,         right: 0.0)

        lineSelection.contentInset          = contentInset
        lineSelection.scrollIndicatorInsets = scrollIndicatorInsets
      }
    }

    fixInsets(in: self.tramSelectionControl)
    fixInsets(in: self.busSelectionControl)
  }
}

//MARK: - State

extension SearchViewController {
  fileprivate func restoreState() {
    let state = SearchViewControllerStateManager.instance.getState()
    self.lineTypeSelector.selectedSegmentIndex = LineTypeIndex.tram
    self.selectedLines = state.selectedLines
  }

  fileprivate func saveState() {
    let state = SearchViewControllerState(selectedLines: self.selectedLines)
    SearchViewControllerStateManager.instance.saveState(state: state)
  }
}

//MARK: - CardPanelPresentable

extension SearchViewController : CardPanelPresentable {
  var contentView:       UIView { return self.view }
  var interactionTarget: UIView { return self.headerView }
}
