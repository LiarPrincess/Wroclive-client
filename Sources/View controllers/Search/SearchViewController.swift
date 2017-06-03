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
    self.updateLineSelectionControlVisibility()
  }

  //MARK: - Actions

  @objc func saveButtonPressed() {
    logger.info("saveButtonPressed")
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
    let tramLines = lines.filter { $0.type == .tram }
    let busLines = lines.filter { $0.type == .bus }

    self.tramSelectionControl = LineSelectionControl(withLines: tramLines)
    self.busSelectionControl  = LineSelectionControl(withLines: busLines)
  }

  private func updateLineSelectionControlVisibility() {
    let selectedIndex = self.lineTypeSelector.selectedSegmentIndex
    self.tramSelectionControl.view.isHidden = selectedIndex != LineTypeIndex.tram
    self.busSelectionControl.view.isHidden  = selectedIndex != LineTypeIndex.bus
  }
}

//MARK: - CardPanelPresentable

extension SearchViewController : CardPanelPresentable {
  var contentView:       UIView { return self.view }
  var interactionTarget: UIView { return self.navigationBarBlurView }
}
