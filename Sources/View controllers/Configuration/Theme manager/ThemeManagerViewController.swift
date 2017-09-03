//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class ThemeManagerViewController: UIViewController {

  // MARK: - Properties

  let scrollView        = UIScrollView()
  let scrollViewContent = UIView()

  let themePresentation = ThemePresentation()

  let configurationTable = IntrinsicTableView(frame: .zero, style: .grouped)
  let colorsCell   = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let shareCell    = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let tutorialCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let contactCell  = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let rateCell     = UITableViewCell(style: .value1, reuseIdentifier: nil)

  // MARK: - Override

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  // MARK: - Actions

  @objc func closeButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }
}

// MARK: - UIScrollViewDelegate

extension ThemeManagerViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.updateScrollViewBackgroundColor()
  }

  private func updateScrollViewBackgroundColor() {
    let gradientColor = PresentationControllerConstants.Colors.Gradient.colors.first
    let tableColor    = self.configurationTable.backgroundColor

    let scrollPosition  = scrollView.contentOffset.y
    let backgroundColor = scrollPosition <= 0.0 ? gradientColor : tableColor

    if let backgroundColor = backgroundColor, self.scrollView.backgroundColor != backgroundColor {
      self.scrollView.backgroundColor = backgroundColor
    }
  }
}

// MARK: - UITableViewDataSource

extension ThemeManagerViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 1
    case 1: return 4
    default: fatalError("Unexpected section")
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
    case (0, 0): return self.colorsCell
    case (1, 0): return self.shareCell
    case (1, 1): return self.tutorialCell
    case (1, 2): return self.contactCell
    case (1, 3): return self.rateCell
    default: fatalError("Unexpected (section, row)")
    }
  }
}
