//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import ReSwift

struct BookmarksViewControllerConstants {
  static let cellIdentifier = "BookmarkCell"
}

class BookmarksViewController: UIViewController {

  //MARK: - Static

  static let identifier = "BookmarksViewController"

  //MARK: - Properties

  fileprivate let bookmarksDataSource = BookmarksDataSource()

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var tableView: UITableView!

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.dataSource = self.bookmarksDataSource
    self.tableView.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    store.subscribe(self) { state in state.bookmarksState }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    store.unsubscribe(self)
  }

  //MARK: - Actions

  @IBAction func closeButtonPressed(_ sender: Any) {
    store.dispatch(SetBookmarksVisibility(false))
  }

}

//MARK: - StoreSubscriber

extension BookmarksViewController: StoreSubscriber {

  func newState(state: BookmarksState) {
    guard state.visible else {
      self.dismiss(animated: true, completion: nil)
      return
    }

    if self.bookmarksDataSource.bookmarks != state.bookmarks {
      self.bookmarksDataSource.bookmarks = state.bookmarks
    }
  }

}

//MARK: - TableViewDelegate

extension BookmarksViewController: UITableViewDelegate {

  //MARK: - Display

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    self.customizeAppearance(cell as! BookmarkCell)
  }

  private func customizeAppearance(_ cell: BookmarkCell) {
    cell.labelName.font = UIFont.customPreferredFont(forTextStyle: .headline)
    cell.labelTramLines.font = UIFont.customPreferredFont(forTextStyle: .subheadline)
    cell.labelBusLines.font  = UIFont.customPreferredFont(forTextStyle: .subheadline)

    cell.labelTramLines.textColor = self.view.tintColor
    cell.labelBusLines.textColor = self.view.tintColor
  }

  //MARK: - Height

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.rowHeight
  }

}
