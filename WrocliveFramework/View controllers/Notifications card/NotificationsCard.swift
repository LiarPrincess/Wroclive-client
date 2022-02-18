// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public final class NotificationsCard: UIViewController,
                                      UITableViewDataSource, UITableViewDelegate,
                                      NotificationsCardViewType, CardPresentable {

  // MARK: - Properties

  public let headerView = ExtraLightVisualEffectView()

  public let titleLabel = UILabel()
  public let placeholderView = NotificationsPlaceholderView()
  public let tableView = UITableView()

  /// `self.tableView` data source
  internal var notifications = ["A", "B", "C"]
  internal let viewModel: NotificationsCardViewModel

  // MARK: - Init

  public init(viewModel: NotificationsCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    viewModel.setView(view: self)
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.inset(scrollView: self.tableView, below: self.headerView)
  }

  // MARK: - View model

  public func refresh() {
  }

  public func close(animated: Bool) {
    self.dismiss(animated: animated, completion: nil)
  }

  // MARK: - CardPresentable

  public var scrollView: UIScrollView? {
    let isTableViewVisible = !self.tableView.isHidden
    return isTableViewVisible ? self.tableView : nil
  }

  // MARK: - UITableView

  public func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
    return self.notifications.count
  }

  public func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let notification = self.notifications[indexPath.row]
    let cell = self.tableView.dequeueCell(ofType: NotificationsCell.self,
                                          forIndexPath: indexPath)

    cell.update(notification: notification)
    return cell
  }
}