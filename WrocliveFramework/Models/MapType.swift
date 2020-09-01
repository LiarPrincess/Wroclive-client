// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import MapKit

public enum MapType: CustomStringConvertible {

  public static let `default` = MapType.standard

  /// A street map that shows the position of all roads and some road names.
  case standard
  /// Satellite imagery of the area.
  case satellite
  /// A satellite image of the area with road and road name information layered on top.
  case hybrid

  public var description: String {
    switch self {
    case .standard: return "Standard"
    case .satellite: return "Satellite"
    case .hybrid: return "Hybrid"
    }
  }

  public var value: MKMapType {
    switch self {
    case .standard: return .standard
    case .satellite: return .satellite
    case .hybrid: return .hybrid
    }
  }
}
