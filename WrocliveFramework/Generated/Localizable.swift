// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable nesting
// swiftlint:disable vertical_whitespace
// swiftlint:disable explicit_type_interface
// swiftlint:disable identifier_name
// swiftlint:disable type_body_length
// swiftlint:disable line_length
// swiftlint:disable trailing_newline

import Foundation


public enum Localizable {

  enum Alert {

    enum Bookmark {

      enum NameInput {
        /// Cancel
        static let cancel = Localizable.tr("Localizable", "Alert.Bookmark.NameInput.Cancel")
        /// Enter name for this bookmark.
        static let message = Localizable.tr("Localizable", "Alert.Bookmark.NameInput.Message")
        /// Name
        static let placeholder = Localizable.tr("Localizable", "Alert.Bookmark.NameInput.Placeholder")
        /// Save
        static let save = Localizable.tr("Localizable", "Alert.Bookmark.NameInput.Save")
        /// New bookmark
        static let title = Localizable.tr("Localizable", "Alert.Bookmark.NameInput.Title")
      }

      enum NoLinesSelected {
        /// Please select some lines before trying to create bookmark.
        static let message = Localizable.tr("Localizable", "Alert.Bookmark.NoLinesSelected.Message")
        /// OK
        static let ok = Localizable.tr("Localizable", "Alert.Bookmark.NoLinesSelected.Ok")
        /// No lines selected
        static let title = Localizable.tr("Localizable", "Alert.Bookmark.NoLinesSelected.Title")
      }
    }

    enum InvalidCity {
      /// Wroclive works best in Wrocław.\nWould you like to visit?
      static let message = Localizable.tr("Localizable", "Alert.InvalidCity.Message")
      /// No
      static let no = Localizable.tr("Localizable", "Alert.InvalidCity.No")
      /// Adventure time!
      static let title = Localizable.tr("Localizable", "Alert.InvalidCity.Title")
      /// Yes
      static let yes = Localizable.tr("Localizable", "Alert.InvalidCity.Yes")
    }

    enum Location {

      enum Denied {
        /// Turn on Location Services in Settings > Privacy to allow to determine your current location.
        static let message = Localizable.tr("Localizable", "Alert.Location.Denied.Message")
        /// OK
        static let ok = Localizable.tr("Localizable", "Alert.Location.Denied.Ok")
        /// Settings
        static let settings = Localizable.tr("Localizable", "Alert.Location.Denied.Settings")
        /// Location Services Off
        static let title = Localizable.tr("Localizable", "Alert.Location.Denied.Title")
      }

      enum GloballyDenied {
        /// Turn on Location Services in Settings > Privacy to allow to determine your current location.
        static let message = Localizable.tr("Localizable", "Alert.Location.GloballyDenied.Message")
        /// OK
        static let ok = Localizable.tr("Localizable", "Alert.Location.GloballyDenied.Ok")
        /// Location Services Off
        static let title = Localizable.tr("Localizable", "Alert.Location.GloballyDenied.Title")
      }
    }

    enum Network {

      enum ConnectionError {
        /// Could not connect to server.
        static let message = Localizable.tr("Localizable", "Alert.Network.ConnectionError.Message")
        /// Unable to retrieve data
        static let title = Localizable.tr("Localizable", "Alert.Network.ConnectionError.Title")
        /// Try again
        static let tryAgain = Localizable.tr("Localizable", "Alert.Network.ConnectionError.TryAgain")
      }

      enum NoInternet {
        /// Please check your internet connection.
        static let message = Localizable.tr("Localizable", "Alert.Network.NoInternet.Message")
        /// Unable to retrieve data
        static let title = Localizable.tr("Localizable", "Alert.Network.NoInternet.Title")
        /// Try again
        static let tryAgain = Localizable.tr("Localizable", "Alert.Network.NoInternet.TryAgain")
      }
    }
  }

  enum Bookmarks {
    /// Bookmarks
    static let title = Localizable.tr("Localizable", "Bookmarks.Title")

    enum Edit {
      /// Done
      static let done = Localizable.tr("Localizable", "Bookmarks.Edit.Done")
      /// Edit
      static let edit = Localizable.tr("Localizable", "Bookmarks.Edit.Edit")
    }

    enum Placeholder {
      /// To add bookmark press <heart> when selecting lines.
      static let content = Localizable.tr("Localizable", "Bookmarks.Placeholder.Content")
      /// You have not saved any bookmarks
      static let title = Localizable.tr("Localizable", "Bookmarks.Placeholder.Title")
    }
  }

  enum Search {
    /// Loading…
    static let loading = Localizable.tr("Localizable", "Search.Loading")
    /// Select
    static let search = Localizable.tr("Localizable", "Search.Search")
    /// Lines
    static let title = Localizable.tr("Localizable", "Search.Title")

    enum Pages {
      /// Buses
      static let bus = Localizable.tr("Localizable", "Search.Pages.Bus")
      /// Trams
      static let tram = Localizable.tr("Localizable", "Search.Pages.Tram")
    }

    enum Sections {
      /// Express
      static let express = Localizable.tr("Localizable", "Search.Sections.Express")
      /// Limited
      static let limited = Localizable.tr("Localizable", "Search.Sections.Limited")
      /// Night
      static let night = Localizable.tr("Localizable", "Search.Sections.Night")
      /// Peak-hour
      static let peakHour = Localizable.tr("Localizable", "Search.Sections.PeakHour")
      /// Regular
      static let regular = Localizable.tr("Localizable", "Search.Sections.Regular")
      /// Suburban
      static let suburban = Localizable.tr("Localizable", "Search.Sections.Suburban")
      /// Temporary
      static let temporary = Localizable.tr("Localizable", "Search.Sections.Temporary")
      /// Zone
      static let zone = Localizable.tr("Localizable", "Search.Sections.Zone")
    }
  }

  enum Settings {
    /// Data provided by MPK Wrocław
    static let footer = Localizable.tr("Localizable", "Settings.Footer")
    /// Settings
    static let title = Localizable.tr("Localizable", "Settings.Title")

    enum Table {

      enum General {
        /// About
        static let about = Localizable.tr("Localizable", "Settings.Table.General.About")
        /// General
        static let header = Localizable.tr("Localizable", "Settings.Table.General.Header")
        /// Rate app
        static let rate = Localizable.tr("Localizable", "Settings.Table.General.Rate")
        /// Share
        static let share = Localizable.tr("Localizable", "Settings.Table.General.Share")
      }

      enum MapType {
        /// Map type
        static let header = Localizable.tr("Localizable", "Settings.Table.MapType.Header")
        /// Hybrid
        static let hybrid = Localizable.tr("Localizable", "Settings.Table.MapType.Hybrid")
        /// Satellite
        static let satellite = Localizable.tr("Localizable", "Settings.Table.MapType.Satellite")
        /// Standard
        static let standard = Localizable.tr("Localizable", "Settings.Table.MapType.Standard")
      }

      enum Programming {
        /// Programming
        static let header = Localizable.tr("Localizable", "Settings.Table.Programming.Header")
        /// Report error
        static let reportError = Localizable.tr("Localizable", "Settings.Table.Programming.ReportError")
        /// Show code
        static let showCode = Localizable.tr("Localizable", "Settings.Table.Programming.ShowCode")
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

  private static var currentLocale = Locale.base

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

