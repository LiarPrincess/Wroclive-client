// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

protocol BundleManagerType {

  /// App name (e.g. Wroclive)
  var name: String { get }

  /// App version (e.g. 1.0)
  var version: String { get }

  /// App bundle (e.g. pl.nopoint.wroclive)
  var identifier: String { get }
}
