// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable explicit_type_interface
// swiftlint:disable identifier_name
// swiftlint:disable line_length
// swiftlint:disable nesting
// swiftlint:disable nslocalizedstring_key
// swiftlint:disable trailing_newline
// swiftlint:disable type_body_length
// swiftlint:disable vertical_whitespace

import Foundation


// Do not add your own caching layer (for example by using 'static let').
// iOS has its own cache that correctly reacts to language changes etc.
// (And also we want to be able ti change language in snapshot tests.)
public enum Localizable {

  enum Alert {

    enum Bookmark {
      /// Bookmark saved
      static var saved: String { Localizable.tr("Localizable", "Alert.Bookmark.Saved") }

      enum NameInput {
        /// Cancel
        static var cancel: String { Localizable.tr("Localizable", "Alert.Bookmark.NameInput.Cancel") }
        /// Enter name for this bookmark.
        static var message: String { Localizable.tr("Localizable", "Alert.Bookmark.NameInput.Message") }
        /// Name
        static var placeholder: String { Localizable.tr("Localizable", "Alert.Bookmark.NameInput.Placeholder") }
        /// Save
        static var save: String { Localizable.tr("Localizable", "Alert.Bookmark.NameInput.Save") }
        /// New bookmark
        static var title: String { Localizable.tr("Localizable", "Alert.Bookmark.NameInput.Title") }
      }

      enum NoLinesSelected {
        /// Please select some lines before trying to create bookmark.
        static var message: String { Localizable.tr("Localizable", "Alert.Bookmark.NoLinesSelected.Message") }
        /// OK
        static var ok: String { Localizable.tr("Localizable", "Alert.Bookmark.NoLinesSelected.Ok") }
        /// No lines selected
        static var title: String { Localizable.tr("Localizable", "Alert.Bookmark.NoLinesSelected.Title") }
      }
    }

    enum InvalidCity {
      /// Wroclive works best in Wrocław.\nWould you like to visit?
      static var message: String { Localizable.tr("Localizable", "Alert.InvalidCity.Message") }
      /// No
      static var no: String { Localizable.tr("Localizable", "Alert.InvalidCity.No") }
      /// Adventure time!
      static var title: String { Localizable.tr("Localizable", "Alert.InvalidCity.Title") }
      /// Yes
      static var yes: String { Localizable.tr("Localizable", "Alert.InvalidCity.Yes") }
    }

    enum Location {

      enum Denied {
        /// Turn on Location Services in Settings > Privacy to allow to determine your current location.
        static var message: String { Localizable.tr("Localizable", "Alert.Location.Denied.Message") }
        /// OK
        static var ok: String { Localizable.tr("Localizable", "Alert.Location.Denied.Ok") }
        /// Settings
        static var settings: String { Localizable.tr("Localizable", "Alert.Location.Denied.Settings") }
        /// Location Services Off
        static var title: String { Localizable.tr("Localizable", "Alert.Location.Denied.Title") }
      }

      enum GloballyDenied {
        /// Turn on Location Services in Settings > Privacy to allow to determine your current location.
        static var message: String { Localizable.tr("Localizable", "Alert.Location.GloballyDenied.Message") }
        /// OK
        static var ok: String { Localizable.tr("Localizable", "Alert.Location.GloballyDenied.Ok") }
        /// Location Services Off
        static var title: String { Localizable.tr("Localizable", "Alert.Location.GloballyDenied.Title") }
      }
    }

    enum Network {

      enum ConnectionError {
        /// Could not connect to server.
        static var message: String { Localizable.tr("Localizable", "Alert.Network.ConnectionError.Message") }
        /// Unable to retrieve data
        static var title: String { Localizable.tr("Localizable", "Alert.Network.ConnectionError.Title") }
        /// Try again
        static var tryAgain: String { Localizable.tr("Localizable", "Alert.Network.ConnectionError.TryAgain") }
      }

      enum NoInternet {
        /// Please check your internet connection.
        static var message: String { Localizable.tr("Localizable", "Alert.Network.NoInternet.Message") }
        /// Unable to retrieve data
        static var title: String { Localizable.tr("Localizable", "Alert.Network.NoInternet.Title") }
        /// Try again
        static var tryAgain: String { Localizable.tr("Localizable", "Alert.Network.NoInternet.TryAgain") }
      }
    }
  }

  enum Bookmarks {
    /// Bookmarks
    static var title: String { Localizable.tr("Localizable", "Bookmarks.Title") }

    enum Edit {
      /// Done
      static var done: String { Localizable.tr("Localizable", "Bookmarks.Edit.Done") }
      /// Edit
      static var edit: String { Localizable.tr("Localizable", "Bookmarks.Edit.Edit") }
    }

    enum Placeholder {
      /// To add bookmark press <heart> when selecting lines.
      static var content: String { Localizable.tr("Localizable", "Bookmarks.Placeholder.Content") }
      /// You have not saved any bookmarks
      static var title: String { Localizable.tr("Localizable", "Bookmarks.Placeholder.Title") }
    }
  }

  enum Search {
    /// Loading…
    static var loading: String { Localizable.tr("Localizable", "Search.Loading") }
    /// Select
    static var search: String { Localizable.tr("Localizable", "Search.Search") }
    /// Lines
    static var title: String { Localizable.tr("Localizable", "Search.Title") }

    enum Pages {
      /// Buses
      static var bus: String { Localizable.tr("Localizable", "Search.Pages.Bus") }
      /// Trams
      static var tram: String { Localizable.tr("Localizable", "Search.Pages.Tram") }
    }

    enum Sections {
      /// Express
      static var express: String { Localizable.tr("Localizable", "Search.Sections.Express") }
      /// Limited
      static var limited: String { Localizable.tr("Localizable", "Search.Sections.Limited") }
      /// Night
      static var night: String { Localizable.tr("Localizable", "Search.Sections.Night") }
      /// Peak-hour
      static var peakHour: String { Localizable.tr("Localizable", "Search.Sections.PeakHour") }
      /// Regular
      static var regular: String { Localizable.tr("Localizable", "Search.Sections.Regular") }
      /// Suburban
      static var suburban: String { Localizable.tr("Localizable", "Search.Sections.Suburban") }
      /// Temporary
      static var temporary: String { Localizable.tr("Localizable", "Search.Sections.Temporary") }
      /// Zone
      static var zone: String { Localizable.tr("Localizable", "Search.Sections.Zone") }
    }
  }

  enum Settings {
    /// 
    static var footer: String { Localizable.tr("Localizable", "Settings.Footer") }
    /// Settings
    static var title: String { Localizable.tr("Localizable", "Settings.Title") }

    enum Table {

      enum General {
        /// General
        static var header: String { Localizable.tr("Localizable", "Settings.Table.General.Header") }
        /// Privacy policy
        static var privacyPolicy: String { Localizable.tr("Localizable", "Settings.Table.General.PrivacyPolicy") }
        /// Rate app
        static var rate: String { Localizable.tr("Localizable", "Settings.Table.General.Rate") }
        /// Share
        static var share: String { Localizable.tr("Localizable", "Settings.Table.General.Share") }
      }

      enum MapType {
        /// Map type
        static var header: String { Localizable.tr("Localizable", "Settings.Table.MapType.Header") }
        /// Hybrid
        static var hybrid: String { Localizable.tr("Localizable", "Settings.Table.MapType.Hybrid") }
        /// Satellite
        static var satellite: String { Localizable.tr("Localizable", "Settings.Table.MapType.Satellite") }
        /// Standard
        static var standard: String { Localizable.tr("Localizable", "Settings.Table.MapType.Standard") }
      }

      enum Programming {
        /// Application
        static var header: String { Localizable.tr("Localizable", "Settings.Table.Programming.Header") }
        /// Support and feedback
        static var reportError: String { Localizable.tr("Localizable", "Settings.Table.Programming.ReportError") }
        /// Show code
        static var showCode: String { Localizable.tr("Localizable", "Settings.Table.Programming.ShowCode") }
      }
    }
  }

  enum Share {
    /// Wroclive - Real time public transport! %@
    static func message(_ p1: String) -> String {
      return Localizable.tr("Localizable", "Share.Message", p1)
    }
  }
}

// MARK: - Helpers

private final class BundleToken { }

extension Localizable {

  public struct Locale: CustomStringConvertible {
    let name: String
    let locale: Foundation.Locale
    let bundle: Foundation.Bundle

    public var description: String {
      return self.name
    }

    public static let base = Locale(name: "base",
                                    locale: Foundation.Locale.current,
                                    bundle: Bundle(for: BundleToken.self))

    public static let en = Locale(name: "en",
                                  localeIdentifier: "en",
                                  bundleLanguage: "Base")

    public static let pl = Locale(name: "pl",
                                  localeIdentifier: "pl",
                                  bundleLanguage: "pl")

    private init(name: String,
                 locale: Foundation.Locale,
                 bundle: Foundation.Bundle) {
      self.name = name
      self.locale = locale
      self.bundle = bundle
    }

    private init(name: String,
                 localeIdentifier: String,
                 bundleLanguage: String) {
      self.name = name
      self.locale = Foundation.Locale(identifier: localeIdentifier)
      self.bundle = Self.createBundle(language: bundleLanguage)
    }

    private static func createBundle(language: String) -> Bundle {
      let frameworkBundle = Bundle(for: BundleToken.self)

      guard let path = frameworkBundle.path(forResource: language, ofType: "lproj") else {
        fatalError("Unable to find '\(language).lproj'")
      }

      guard let bundle = Bundle(path: path) else {
        fatalError("Unable to create bundle for '\(path)'")
      }

      return bundle
    }
  }

  public private(set) static var currentLocale = Locale.base

#if DEBUG
  /// This will only affect UI text! Nothing else!
  public static func setLocale(_ value: Locale) {
    Self.currentLocale = value
  }
#endif

  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let locale = Self.currentLocale
    let format = NSLocalizedString(key,
                                   tableName: table,
                                   bundle: locale.bundle,
                                   comment: "")
    return String(format: format, locale: locale.locale, arguments: args)
  }
}

