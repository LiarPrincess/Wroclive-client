//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import ReSwift

fileprivate struct BookmarksConstants {
  static let cellIdentifier = "BookmarkCell"
}

class BookmarksViewController: UIViewController {

  //MARK: - Static

  static let identifier = "BookmarksViewController"

  //MARK: - Properties

  fileprivate var bookmarks = [Bookmark]()

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var tableView: UITableView!

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.dataSource = self
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

    self.bookmarks = state.bookmarks
  }

}

//MARK: - TableView

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.bookmarks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarksConstants.cellIdentifier, for: indexPath) as? BookmarkCell  else {
      fatalError("The dequeued cell is not an instance of BookmarksTableViewCell")
    }

    self.customizeAppearance(cell)

    let bookmark = self.bookmarks[indexPath.row]
    cell.labelName.text = bookmark.name
    cell.labelTramLines.text = bookmark.lines.filter { $0.type == .tram }.map { $0.name }.joined(separator: "  ")
    cell.labelBusLines.text = bookmark.lines.filter { $0.type == .bus }.map { $0.name }.joined(separator: "  ")
    return cell
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.rowHeight
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  private func customizeAppearance(_ cell: BookmarkCell) {
    cell.labelName.font = UIFont.customPreferredFont(forTextStyle: .headline)
    cell.labelTramLines.font = UIFont.customPreferredFont(forTextStyle: .subheadline)
    cell.labelBusLines.font  = UIFont.customPreferredFont(forTextStyle: .subheadline)

    cell.labelTramLines.textColor = self.view.tintColor
    cell.labelBusLines.textColor = self.view.tintColor
  }

}
