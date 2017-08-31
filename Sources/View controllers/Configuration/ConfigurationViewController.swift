//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants = ConfigurationViewControllerConstants

class ConfigurationViewController: UIViewController {

  // MARK: - Properties

  let scrollView  = UIScrollView()
  let contentView = UIView()

  let inAppPurchasePresentation = InAppPurchasePresentation()

  let configurationTable = IntrinsicTableView(frame: .zero, style: .grouped)
  let colorsCell   = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let shareCell    = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let tutorialCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let contactCell  = UITableViewCell(style: .value1, reuseIdentifier: nil)
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
    case (0, 0): self.showThemeManager()
    case (1, 0): Managers.app.showShareActivity(in: self)
    case (1, 1): self.showTutorial()
    case (1, 2): Managers.app.openWebsite()
    case (1, 3): Managers.appStore.rateApp()
    default: fatalError("Unexpected row")
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  private func showThemeManager() {
    let currentColor = Managers.theme.colorScheme.tintColor
    let nextColor = self.nextColor(after: currentColor)

    Managers.theme.setColorScheme(tint: nextColor, bus: .red, tram: .blue)

//    let viewController = ThemeManagerViewController()
//    self.navigationController!.pushViewController(viewController, animated: true)
  }

  private func nextColor(after color: TintColor) -> TintColor {
    let allColors = [TintColor](self.iterateEnum(TintColor.self))

    var flag = false
    for col in allColors {
      if flag {
        return col
      }
      flag = col == color
    }

    return allColors.first!
  }

  private func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
      let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
      if next.hashValue != i { return nil }
      i += 1
      return next
    }
  }

  private func showTutorial() {
    let viewController = TutorialPresentation()
    self.navigationController!.pushViewController(viewController, animated: true)
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
