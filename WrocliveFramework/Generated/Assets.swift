// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable vertical_whitespace
// swiftlint:disable identifier_name
// swiftlint:disable type_body_length


#if os(OSX)
import AppKit.NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIImage
#endif

private final class BundleToken {}

public struct ImageAsset {

#if os(OSX)
  public typealias Value = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Value = UIImage
#endif

  public let name: String

  public static let bookmarksPlaceholderHeart = ImageAsset(name: "bookmarks-placeholder-heart")
  public static let searchHeart = ImageAsset(name: "search-heart")
  public static let settingsAbout = ImageAsset(name: "settings-about")
  public static let settingsPrivacyPolicy = ImageAsset(name: "settings-privacy-policy")
  public static let settingsRate = ImageAsset(name: "settings-rate")
  public static let settingsReportError = ImageAsset(name: "settings-report-error")
  public static let settingsShare = ImageAsset(name: "settings-share")
  public static let settingsShowCode = ImageAsset(name: "settings-show-code")
  public static let share = ImageAsset(name: "share")
  public static let toolbarGear = ImageAsset(name: "toolbar-gear")
  public static let toolbarHeart = ImageAsset(name: "toolbar-heart")
  public static let toolbarTram = ImageAsset(name: "toolbar-tram")

  public var value: Value {
    let bundle = Bundle(for: BundleToken.self)

    #if os(iOS) || os(tvOS)
    let image = Value(named: self.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(self.name))
    #elseif os(watchOS)
    let image = Value(named: self.name)
    #endif

    guard let result = image else {
      fatalError("Unable to load image named \(self.name).")
    }

    return result
  }
}

public struct ColorAsset {

#if os(OSX)
  public typealias Value = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Value = UIColor
#endif

  public let name: String


  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  public var value: Value {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let color = Value(named: self.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let color = Value(named: NSColor.Name(self.name), bundle: bundle)
    #elseif os(watchOS)
    let color = Value(named: self.name)
    #endif

    guard let result = color else {
      fatalError("Unable to load color named \(self.name).")
    }

    return result
  }
}
