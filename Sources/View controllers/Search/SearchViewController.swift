//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = SearchViewControllerConstants

class SearchViewController: UIViewController {

  //MARK: - Properties

  var selectedLines = [Line]()

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
    self.loadPreviousState()
    self.updateLineSelectionControlVisibility()
  }

  override func viewWillDisappear(_ animated: Bool) {
    let state = SearchViewControllerState(selectedLines: self.selectedLines)
    SearchViewControllerStateManager.instance.saveState(state: state)
  }

  //MARK: - Actions

  @objc func saveButtonPressed() {
    let alertController = UIAlertController(title: "Add bookmark", message: nil, preferredStyle: .alert)

    alertController.addTextField { textField in
      textField.placeholder            = "Name"
      textField.autocapitalizationType = .sentences
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)

    let saveAction = UIAlertAction(title: "Save", style: .default) { [weak alertController, weak self] _ in
      guard let nameTextField = alertController?.textFields![0], let selectedLines = self?.selectedLines else {
        return
      }

      let name = nameTextField.text ?? ""
      let bookmark = Bookmark(name: name, lines: selectedLines)
      BookmarksManager.instance.add(bookmark: bookmark)
    }
    alertController.addAction(saveAction)

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
    let tramLines = lines.filter { $0.type == .tram }
    let busLines = lines.filter { $0.type == .bus }

    self.tramSelectionControl = LineSelectionControl(withLines: tramLines, delegate: self)
    self.busSelectionControl  = LineSelectionControl(withLines: busLines, delegate: self)
  }

  private func loadPreviousState() {
    self.lineTypeSelector.selectedSegmentIndex = LineTypeIndex.tram

    let state = SearchViewControllerStateManager.instance.getState()
    for line in state.selectedLines {
      let control = line.type == .tram ? self.tramSelectionControl : self.busSelectionControl
      control?.select(line: line)
    }
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

//MARK: - LineSelectionControlDelegate

extension SearchViewController: LineSelectionControlDelegate {

  func lineSelectionControl(_ control: LineSelectionControl, didSelect line: Line) {
    self.selectedLines.append(line)
  }

  func lineSelectionControl(_ control: LineSelectionControl, didDeselect line: Line) {
    if let index = self.selectedLines.index(of: line) {
      self.selectedLines.remove(at: index)
    }
  }
}
