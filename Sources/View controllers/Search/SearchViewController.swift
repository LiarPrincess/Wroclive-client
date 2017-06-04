//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = SearchViewControllerConstants

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

  let navigationBarBlur = UIBlurEffect(style: .extraLight)

  lazy var navigationBarBlurView: UIVisualEffectView =  {
    return UIVisualEffectView(effect: self.navigationBarBlur)
  }()

  let navigationBar    = UINavigationBar()
  let saveButton       = UIBarButtonItem()
  let searchButton     = UIBarButtonItem()
  
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
    self.updateLineSelectionControlVisibility()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.updateLineSelectionInsets()
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
    self.updateLineSelectionControlVisibility()
  }

  //MARK: - Methods

  private func initLineSelectionControls() {
    let lines = LinesManager.instance.getLines()
    self.tramSelectionControl = LineSelectionControl(withLines: lines.filter { $0.type == .tram })
    self.busSelectionControl  = LineSelectionControl(withLines: lines.filter { $0.type == .bus })
  }

  private func updateLineSelectionControlVisibility() {
    let selectedIndex = self.lineTypeSelector.selectedSegmentIndex
    self.tramSelectionControl.view.isHidden = selectedIndex != LineTypeIndex.tram
    self.busSelectionControl.view.isHidden  = selectedIndex != LineTypeIndex.bus
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
  var interactionTarget: UIView { return self.navigationBarBlurView }
}
