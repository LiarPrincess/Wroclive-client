// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// This has to be on Collection, because Sequence does not
// guarantee multi-traversal or nondestructive access!
extension Collection {
  var any: Bool { return !self.isEmpty }
}
