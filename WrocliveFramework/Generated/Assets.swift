// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable vertical_whitespace
// swiftlint:disable deployment_target
// swiftlint:disable identifier_name
// swiftlint:disable type_body_length


#if os(OSX)
  import AppKit.NSImage
  typealias AssetColorTypeAlias = NSColor
  typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias AssetColorTypeAlias = UIColor
  typealias Image = UIImage
#endif

@available(*, deprecated, renamed: "ImageAsset")
typealias AssetsType = ImageAsset

struct ImageAsset {
  fileprivate(set) var name: String

  var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

struct ColorAsset {
  fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

enum Assets {
  static let shareImage = ImageAsset(name: "ShareImage")
  static let bookmarksPlaceholderHeart = ImageAsset(name: "bookmarks-placeholder-heart")
  static let searchHeart = ImageAsset(name: "search-heart")
  static let tabbarBookmarks = ImageAsset(name: "tabbar-bookmarks")
  static let tabbarNotifications = ImageAsset(name: "tabbar-notifications")
  static let tabbarSearch = ImageAsset(name: "tabbar-search")
  static let tabbarSettings = ImageAsset(name: "tabbar-settings")
  static let toolbarGear = ImageAsset(name: "toolbar-gear")
  static let toolbarHeart = ImageAsset(name: "toolbar-heart")
  static let toolbarTram = ImageAsset(name: "toolbar-tram")
}

extension Image {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
