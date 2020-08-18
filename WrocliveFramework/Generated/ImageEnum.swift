// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable all

private final class BundleToken {}

public enum ImageEnum {
  case tram
  case heart
  case gear
  case about
  case share
  case rate

  public var imageName: String {
    switch self {
    case .tram: return "tram.empty"
    case .heart: return "heart"
    case .gear: return "gearshape"
    case .about: return "info.circle"
    case .share: return "square.and.arrow.up"
    case .rate: return "star.leadinghalf.fill"
    }
  }

  public var value: UIImage {
    let bundle = Bundle(for: BundleToken.self)

//    func image(named: String) -> UIImage {
//      return UIImage(named: named, in: bundle, compatibleWith: nil)!
//    }
//
//    switch self {
//    case .tram: return image(named: "tabbar-tram")
//    case .heart: return image(named: "tabbar-heart")
//    case .gear: return image(named: "tabbar-gear")
//    default: break
//    }

    let name = self.imageName

    if #available(iOS 13.0, *) {
      let configuration = UIImage.SymbolConfiguration(pointSize: 20.0,
                                                      weight: .regular,
                                                      scale: .medium)
      if let image = UIImage(named: name, in: bundle, with: configuration) {
        return image
      }
    } else {
      if let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
        return image
      }
    }

    return UIImage(named: "tabbar-bookmarks", in: bundle, compatibleWith: nil)!
  }
}
