// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

//=======================================================================
//
// This file is computer generated from Localizable.strings. Do not edit.
// Run 'fastlane translate' to generate it again.
//
//=======================================================================

// swiftlint:disable superfluous_disable_command
// swiftlint:disable identifier_name
// swiftlint:disable valid_docs
// swiftlint:disable line_length
// swiftlint:disable type_body_length
// swiftlint:disable file_length

import Foundation

private class BundleHook { }

private func localizedString(_ key: String) -> String {
  let bundle = Bundle(for: BundleHook.self)
  return NSLocalizedString(key, bundle: bundle, comment: "")
}

public struct Localizable {

  enum Alert {

    enum Bookmark {

      enum NameInput {

        /// Cancel
        /// - **en**: Cancel
        /// - **pl**: Anuluj
        static var cancel: String { return localizedString("Alert_Bookmark_NameInput_Cancel") }

        /// Enter name for this bookmark.
        /// - **en**: Enter name for this bookmark.
        /// - **pl**: Wprowadź nazwę nowej zakładki.
        static var message: String { return localizedString("Alert_Bookmark_NameInput_Message") }

        /// Name
        /// - **en**: Name
        /// - **pl**: Nazwa
        static var placeholder: String { return localizedString("Alert_Bookmark_NameInput_Placeholder") }

        /// Save
        /// - **en**: Save
        /// - **pl**: Zachowaj
        static var save: String { return localizedString("Alert_Bookmark_NameInput_Save") }

        /// New bookmark
        /// - **en**: New bookmark
        /// - **pl**: Nowa zakładka
        static var title: String { return localizedString("Alert_Bookmark_NameInput_Title") }
      }

      enum NoLinesSelected {

        /// Please select some lines before trying to create bookmark.
        /// - **en**: Please select some lines before trying to create bookmark.
        /// - **pl**: Zanim dodasz zakładkę musisz zaznaczyć przynajmniej 1 linię.
        static var message: String { return localizedString("Alert_Bookmark_NoLinesSelected_Message") }

        /// OK
        /// - **en**: OK
        /// - **pl**: OK
        static var ok: String { return localizedString("Alert_Bookmark_NoLinesSelected_Ok") }

        /// No lines selected
        /// - **en**: No lines selected
        /// - **pl**: Nie wybrano żadnych linii
        static var title: String { return localizedString("Alert_Bookmark_NoLinesSelected_Title") }
      }
    }

    enum InvalidCity {

      /// Wroclive works best in Wrocław.\nWould you like to visit?
      /// - **en**: Wroclive works best in Wrocław.\nWould you like to visit?
      /// - **pl**: Wroclive działa najlepiej we Wrocławiu.\nPokazać?
      static var message: String { return localizedString("Alert_InvalidCity_Message") }

      /// No
      /// - **en**: No
      /// - **pl**: Nie
      static var no: String { return localizedString("Alert_InvalidCity_No") }

      /// Adventure time!
      /// - **en**: Adventure time!
      /// - **pl**: Pora na przygodę!
      static var title: String { return localizedString("Alert_InvalidCity_Title") }

      /// Yes
      /// - **en**: Yes
      /// - **pl**: Tak
      static var yes: String { return localizedString("Alert_InvalidCity_Yes") }
    }

    enum Location {

      enum Denied {

        /// Turn on Location Services in Settings > Privacy to allow to determine your current location.
        /// - **en**: Turn on Location Services in Settings > Privacy to allow to determine your current location.
        /// - **pl**: Aby określać bieżące położenie, włącz usługi lokalizacji (Ustawienia > Prywatność).
        static var message: String { return localizedString("Alert_Location_Denied_Message") }

        /// OK
        /// - **en**: OK
        /// - **pl**: OK
        static var ok: String { return localizedString("Alert_Location_Denied_Ok") }

        /// Settings
        /// - **en**: Settings
        /// - **pl**: Ustawienia
        static var settings: String { return localizedString("Alert_Location_Denied_Settings") }

        /// Location Services Off
        /// - **en**: Location Services Off
        /// - **pl**: Usługi lokalizacji wyłączone
        static var title: String { return localizedString("Alert_Location_Denied_Title") }
      }

      enum GloballyDenied {

        /// Turn on Location Services in Settings > Privacy to allow to determine your current location.
        /// - **en**: Turn on Location Services in Settings > Privacy to allow to determine your current location.
        /// - **pl**: Aby określać bieżące położenie, włącz usługi lokalizacji (Ustawienia > Prywatność).
        static var message: String { return localizedString("Alert_Location_GloballyDenied_Message") }

        /// OK
        /// - **en**: OK
        /// - **pl**: OK
        static var ok: String { return localizedString("Alert_Location_GloballyDenied_Ok") }

        /// Location Services Off
        /// - **en**: Location Services Off
        /// - **pl**: Usługi lokalizacji wyłączone
        static var title: String { return localizedString("Alert_Location_GloballyDenied_Title") }
      }
    }

    enum Network {

      enum ConnectionError {

        /// Could not connect to server.
        /// - **en**: Could not connect to server.
        /// - **pl**: Błąd połączenia z serwerem.
        static var message: String { return localizedString("Alert_Network_ConnectionError_Message") }

        /// Unable to retrieve data
        /// - **en**: Unable to retrieve data
        /// - **pl**: Nie można pobrać danych
        static var title: String { return localizedString("Alert_Network_ConnectionError_Title") }

        /// Try again
        /// - **en**: Try again
        /// - **pl**: Spróbuj ponownie
        static var tryAgain: String { return localizedString("Alert_Network_ConnectionError_TryAgain") }
      }

      enum NoInternet {

        /// Please check your internet connection.
        /// - **en**: Please check your internet connection.
        /// - **pl**: Sprawdź swoje połączenie z internetem.
        static var message: String { return localizedString("Alert_Network_NoInternet_Message") }

        /// Unable to retrieve data
        /// - **en**: Unable to retrieve data
        /// - **pl**: Nie można pobrać danych
        static var title: String { return localizedString("Alert_Network_NoInternet_Title") }

        /// Try again
        /// - **en**: Try again
        /// - **pl**: Spróbuj ponownie
        static var tryAgain: String { return localizedString("Alert_Network_NoInternet_TryAgain") }
      }
    }
  }

  enum Bookmarks {

    enum Edit {

      /// Done
      /// - **en**: Done
      /// - **pl**: Gotowe
      static var done: String { return localizedString("Bookmarks_Edit_Done") }

      /// Edit
      /// - **en**: Edit
      /// - **pl**: Edycja
      static var edit: String { return localizedString("Bookmarks_Edit_Edit") }
    }

    enum Placeholder {

      /// To add bookmark press <star> when selecting lines.
      /// - **en**: To add bookmark press <star> when selecting lines.
      /// - **pl**: By dodać zakładkę użyj <star> podczas wyboru linii.
      static var content: String { return localizedString("Bookmarks_Placeholder_Content") }

      /// You have not saved any bookmarks
      /// - **en**: You have not saved any bookmarks
      /// - **pl**: Brak zakładek
      static var title: String { return localizedString("Bookmarks_Placeholder_Title") }
    }

    /// Bookmarks
    /// - **en**: Bookmarks
    /// - **pl**: Zakładki
    static var title: String { return localizedString("Bookmarks_Title") }
  }

  enum Search {

    enum Pages {

      /// Buses
      /// - **en**: Buses
      /// - **pl**: Autobusy
      static var bus: String { return localizedString("Search_Pages_Bus") }

      /// Trams
      /// - **en**: Trams
      /// - **pl**: Tramwaje
      static var tram: String { return localizedString("Search_Pages_Tram") }
    }

    enum Sections {

      /// Express
      /// - **en**: Express
      /// - **pl**: Pośpieszne
      static var express: String { return localizedString("Search_Sections_Express") }

      /// Limited
      /// - **en**: Limited
      /// - **pl**: Zastępcze
      static var limited: String { return localizedString("Search_Sections_Limited") }

      /// Night
      /// - **en**: Night
      /// - **pl**: Nocne
      static var night: String { return localizedString("Search_Sections_Night") }

      /// Peak-hour
      /// - **en**: Peak-hour
      /// - **pl**: Szczytowe
      static var peakHour: String { return localizedString("Search_Sections_PeakHour") }

      /// Regular
      /// - **en**: Regular
      /// - **pl**: Normalne
      static var regular: String { return localizedString("Search_Sections_Regular") }

      /// Suburban
      /// - **en**: Suburban
      /// - **pl**: Podmiejskie
      static var suburban: String { return localizedString("Search_Sections_Suburban") }

      /// Temporary
      /// - **en**: Temporary
      /// - **pl**: Tymczasowe
      static var temporary: String { return localizedString("Search_Sections_Temporary") }

      /// Zone
      /// - **en**: Zone
      /// - **pl**: Strefowe
      static var zone: String { return localizedString("Search_Sections_Zone") }
    }

    /// Loading…
    /// - **en**: Loading…
    /// - **pl**: Wczytywanie…
    static var loading: String { return localizedString("Search_Loading") }

    /// Search
    /// - **en**: Search
    /// - **pl**: Szukaj
    static var search: String { return localizedString("Search_Search") }

    /// Lines
    /// - **en**: Lines
    /// - **pl**: Linie
    static var title: String { return localizedString("Search_Title") }
  }

  enum Settings {

    enum Table {

      enum General {

        /// About
        /// - **en**: About
        /// - **pl**: O nas
        static var about: String { return localizedString("Settings_Table_General_About") }

        /// General
        /// - **en**: General
        /// - **pl**: Ogólne
        static var header: String { return localizedString("Settings_Table_General_Header") }

        /// Rate app
        /// - **en**: Rate app
        /// - **pl**: Oceń
        static var rate: String { return localizedString("Settings_Table_General_Rate") }

        /// Share
        /// - **en**: Share
        /// - **pl**: Udostępnij
        static var share: String { return localizedString("Settings_Table_General_Share") }
      }
    }

    /// Data provided by MPK Wrocław
    /// - **en**: Data provided by MPK Wrocław
    /// - **pl**: Dane uzyskano dzięki uprzejmości MPK Wrocław
    static var footer: String { return localizedString("Settings_Footer") }

    /// Settings
    /// - **en**: Settings
    /// - **pl**: Ustawienia
    static var title: String { return localizedString("Settings_Title") }
  }

  enum Share {

    /// Wroclive - Real time public transport! %@
    /// - **en**: Wroclive - Real time public transport! %@
    /// - **pl**: Wroclive - Komunikacja miejska na żywo! %@
    static var message: String { return localizedString("Share_Message") }
  }
}
