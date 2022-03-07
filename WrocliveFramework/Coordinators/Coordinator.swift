// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SafariServices

public protocol Coordinator {}

extension Coordinator {

  internal func openBrowser(parent: UIViewController, url: URL) {
    let safari = SFSafariViewController(url: url)
    safari.preferredControlTintColor = ColorScheme.tint
    safari.modalPresentationStyle = .overFullScreen
    parent.present(safari, animated: true, completion: nil)
  }
}
