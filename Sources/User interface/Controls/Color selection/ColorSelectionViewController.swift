//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Layout = ColorSelectionViewControllerConstants.Layout

class ColorSelectionViewController: UIViewController {

  // MARK: - Properties

  let scrollView        = UIScrollView()
  let scrollViewContent = UIView()

  let themePresentation   = ThemePresentation()
  let tableView           = IntrinsicTableView(frame: .zero, style: .grouped)
  let tableViewDataSource = ColorSelectionDataSource()

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

extension ColorSelectionViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.updateScrollViewBackgroundColor()
  }

  private func updateScrollViewBackgroundColor() {
    let gradientColor = PresentationControllerConstants.Colors.Gradient.colors.first
    let tableColor    = Managers.theme.colorScheme.configurationBackground

    let scrollPosition  = scrollView.contentOffset.y
    let backgroundColor = scrollPosition <= 0.0 ? gradientColor : tableColor

    if let backgroundColor = backgroundColor, self.scrollView.backgroundColor != backgroundColor {
      self.scrollView.backgroundColor = backgroundColor
    }
  }
}

// MARK: - UITableViewDelegate

extension ColorSelectionViewController: UITableViewDelegate {

  // MARK: Height

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    return 50.0
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0 // Layout.Cell.estimatedHeight
  }
}
