// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable identifier_name
// swiftlint:disable line_length
// swiftlint:disable type_body_length
// swiftlint:disable no_extension_access_modifier
// swiftlint:disable conditional_returns_on_newline

#if os(OSX)
  import AppKit.NSFont
  private typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  private typealias Font = UIFont
#endif

// MARK: - Fonts

internal enum Fonts {
  internal enum FontAwesome {
    internal static let regular = FontConvertible(name: "FontAwesome", family: "FontAwesome", path: "FontAwesome.otf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal static let allCustomFonts: [FontConvertible] = [FontAwesome.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  fileprivate func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  fileprivate func register() {
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    let bundle = Bundle(for: BundleToken.self)
    return bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension Font {
  convenience init!(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

private final class BundleToken {}
