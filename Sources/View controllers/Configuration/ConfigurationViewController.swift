//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants    = ConfigurationViewControllerConstants
private typealias Localization = Constants.Localization

class ConfigurationViewController: UIViewController {

  // MARK: - Properties

  let navigationBar = UINavigationBar()

  let scrollView  = UIScrollView()
  let contentView = UIView()

  let inAppPurchasePresentation = InAppPurchasePresentation()

  let configurationTable = IntrinsicTableView(frame: .zero, style: .grouped)
  let colorsCell   = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let shareCell    = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let tutorialCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let rateCell     = UITableViewCell(style: .value1, reuseIdentifier: nil)

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  @objc func closeButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }
}

// MARK: - UINavigationBarDelegate

extension ConfigurationViewController: UINavigationBarDelegate {
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

// MARK: - UIScrollViewDelegate

extension ConfigurationViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.disableTopScrolling(scrollView)
  }

  private func disableTopScrolling(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      scrollView.contentOffset.y = 0.0
    }
  }
}

// MARK: - UITableViewDelegate

extension ConfigurationViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section, indexPath.row) {
    case (0, 0): self.colorsCellPressed()
    case (1, 0): self.shareCellPressed()
    case (1, 1): self.tutorialCellPressed()
    case (1, 2): self.rateCellPressed()
    default: fatalError("Unexpected row")
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  private func colorsCellPressed() {
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }

  private func shareCellPressed() {
    let text    = Localization.Share.Content.text
    let image   = Localization.Share.Content.image
    let items   = [text, image] as [Any] // text, image

    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [.assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .openInIBooks, .print]
    self.present(activityViewController, animated: true, completion: nil)
  }

  private func tutorialCellPressed() {
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }

  private func rateCellPressed() {
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }
}

// MARK: - UITableViewDataSource

extension ConfigurationViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 1
    case 1: return 3
    default: fatalError("Unexpected section")
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
    case (0, 0): return self.colorsCell
    case (1, 0): return self.shareCell
    case (1, 1): return self.tutorialCell
    case (1, 2): return self.rateCell
    default: fatalError("Unexpected row")
    }
  }
}
