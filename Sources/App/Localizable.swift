//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

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

  enum Presentation {

    enum InAppPurchase {

      enum Bookmarks {

        /// Save more than 2 bookmarks to travel faster across the city.
        /// - **en**: Save more than 2 bookmarks to travel faster across the city.
        /// - **pl**: Zapisz więcej niż 2 zakładki, by szybciej poruszać się po mieście.
        static var caption: String { return localizedString("Presentation_InAppPurchase_Bookmarks_Caption") }

        /// Unlimited Bookmarks
        /// - **en**: Unlimited Bookmarks
        /// - **pl**: Nielimitowane zakładki
        static var title: String { return localizedString("Presentation_InAppPurchase_Bookmarks_Title") }
      }

      enum Colors {

        /// Brighten up your life and personalize Wroclive to your favorite color.
        /// - **en**: Brighten up your life and personalize Wroclive to your favorite color.
        /// - **pl**: Dopasuj Wroclive do siebie, by uczynić swój dzień jeszcze bardziej kolorowym!
        static var caption: String { return localizedString("Presentation_InAppPurchase_Colors_Caption") }

        /// Personalization
        /// - **en**: Personalization
        /// - **pl**: Personalizacja
        static var title: String { return localizedString("Presentation_InAppPurchase_Colors_Title") }
      }

      enum Restore {

        /// Restore Purchase
        /// - **en**: Restore Purchase
        /// - **pl**: Odtwórz
        static var link: String { return localizedString("Presentation_InAppPurchase_Restore_Link") }

        /// Previously upgraded?
        /// - **en**: Previously upgraded?
        /// - **pl**: Już kupione?
        static var text: String { return localizedString("Presentation_InAppPurchase_Restore_Text") }
      }

      /// Upgrade 1,09 €
      /// - **en**: Upgrade 1,09 €
      /// - **pl**: Kup 4,99 zł
      static var upgrade: String { return localizedString("Presentation_InAppPurchase_Upgrade") }
    }

    enum Tutorial {

      enum Page0 {

        /// To locate vehicles use <search>, select lines and then tap “Search”.
        /// - **en**: To locate vehicles use <search>, select lines and then tap “Search”.
        /// - **pl**: By wyszukać pojazdy użyj <search>, wybierz linie, a następnie kliknij “Szukaj”.
        static var caption: String { return localizedString("Presentation_Tutorial_Page0_Caption") }

        /// Locating vehicles
        /// - **en**: Locating vehicles
        /// - **pl**: Wyszukiwanie pojazdów
        static var title: String { return localizedString("Presentation_Tutorial_Page0_Title") }
      }

      enum Page1 {

        /// To add bookmark chose lines, tap <star> and enter bookmark name.
        /// - **en**: To add bookmark chose lines, tap <star> and enter bookmark name.
        /// - **pl**: By dodać zakładkę wybierz linie, kliknij <star> i wprowadź nazwę nowej zakładki.
        static var caption: String { return localizedString("Presentation_Tutorial_Page1_Caption") }

        /// Adding bookmarks
        /// - **en**: Adding bookmarks
        /// - **pl**: Dodawanie zakładek
        static var title: String { return localizedString("Presentation_Tutorial_Page1_Title") }
      }

      enum Page2 {

        /// Use <star> to see all saved bookmarks.
        /// - **en**: Use <star> to see all saved bookmarks.
        /// - **pl**: Użyj <star> by zobaczyć wszystkie zapisane zakładki.
        static var caption: String { return localizedString("Presentation_Tutorial_Page2_Caption") }

        /// Bookmarks
        /// - **en**: Bookmarks
        /// - **pl**: Zakładki
        static var title: String { return localizedString("Presentation_Tutorial_Page2_Title") }
      }

      /// Skip
      /// - **en**: Skip
      /// - **pl**: Pomiń
      static var skip: String { return localizedString("Presentation_Tutorial_Skip") }
    }
  }

  enum Search {

    enum BookmarkAdded {

      /// Use <star> from map view to see all saved bookmarks.
      /// - **en**: Use <star> from map view to see all saved bookmarks.
      /// - **pl**: Użyj <star>, by zobaczyć wszystkie zapisane zakładki.
      static var caption: String { return localizedString("Search_BookmarkAdded_Caption") }

      /// Bookmark added!
      /// - **en**: Bookmark added!
      /// - **pl**: Zakładka dodana!
      static var title: String { return localizedString("Search_BookmarkAdded_Title") }
    }

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

        /// Rate app
        /// - **en**: Rate app
        /// - **pl**: Oceń
        static var rate: String { return localizedString("Settings_Table_General_Rate") }

        /// Share
        /// - **en**: Share
        /// - **pl**: Udostępnij
        static var share: String { return localizedString("Settings_Table_General_Share") }

        /// General
        /// - **en**: General
        /// - **pl**: Ogólne
        static var title: String { return localizedString("Settings_Table_General_Title") }
      }

      enum MapType {

        /// Map
        /// - **en**: Map
        /// - **pl**: Mapa
        static var map: String { return localizedString("Settings_Table_MapType_Map") }

        /// Satelite
        /// - **en**: Satelite
        /// - **pl**: Satelitarna
        static var satelite: String { return localizedString("Settings_Table_MapType_Satelite") }

        /// Map type
        /// - **en**: Map type
        /// - **pl**: Typ mapy
        static var title: String { return localizedString("Settings_Table_MapType_Title") }

        /// Transport
        /// - **en**: Transport
        /// - **pl**: Transport
        static var transport: String { return localizedString("Settings_Table_MapType_Transport") }
      }
    }

    enum Theme {

      /// Buses
      /// - **en**: Buses
      /// - **pl**: Autobusy
      static var bus: String { return localizedString("Settings_Theme_Bus") }

      /// Interface
      /// - **en**: Interface
      /// - **pl**: Interfejs
      static var tint: String { return localizedString("Settings_Theme_Tint") }

      /// Trams
      /// - **en**: Trams
      /// - **pl**: Tramwaje
      static var tram: String { return localizedString("Settings_Theme_Tram") }
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
