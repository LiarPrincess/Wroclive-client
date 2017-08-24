//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

// swiftlint:disable identifier_name

private func LocalizedString(_ key: String) -> String {
  return NSLocalizedString(key, comment: "")
}

struct Localizable {

  struct Search {
    static var cardTitle: String { return LocalizedString("Search_CardTitle") }
    static var search:    String { return LocalizedString("Search_Search") }
    static var loading:   String { return LocalizedString("Search_Loading") }
  }

  struct Bookmarks {
    static var cardTitle:          String { return LocalizedString("Bookmarks_CardTitle") }
    static var editEdit:           String { return LocalizedString("Bookmarks_Edit_Edit") }
    static var editDone:           String { return LocalizedString("Bookmarks_Edit_Done") }
    static var placeholderTitle:   String { return LocalizedString("Bookmarks_Placeholder_Title") }
    static var placeholderContent: String { return LocalizedString("Bookmarks_Placeholder_Content") }
  }

  struct Configuration {
    static var Title:  String { return LocalizedString("Configuration_Title") }
    static var Footer: String { return LocalizedString("Configuration_Footer") }

    struct Cells {
      static var colors:   String { return LocalizedString("Configuration_Cell_Colours") }
      static var share:    String { return LocalizedString("Configuration_Cell_Share") }
      static var tutorial: String { return LocalizedString("Configuration_Cell_Tutorial") }
      static var contact:  String { return LocalizedString("Configuration_Cell_Contact") }
      static var rate:     String { return LocalizedString("Configuration_Cell_Rate") }
    }
  }

  struct Controls {
    struct LineSelection {
      static var regular:   String { return LocalizedString("LineSelection_SectionName_Regular") }
      static var express:   String { return LocalizedString("LineSelection_SectionName_Express") }
      static var peakHour:  String { return LocalizedString("LineSelection_SectionName_PeakHour") }
      static var suburban:  String { return LocalizedString("LineSelection_SectionName_Suburban") }
      static var zone:      String { return LocalizedString("LineSelection_SectionName_Zone") }
      static var limited:   String { return LocalizedString("LineSelection_SectionName_Limited") }
      static var temporary: String { return LocalizedString("LineSelection_SectionName_Temporary") }
      static var night:     String { return LocalizedString("LineSelection_SectionName_Night") }
    }

    struct LineTypeSelection {
      static var tram: String { return LocalizedString("LineTypeSelection_Tram") }
      static var bus:  String { return LocalizedString("LineTypeSelection_Bus") }
    }
  }

  struct Presentation {
    struct InAppPurchase {
      static var upgrade: String { return LocalizedString("Presentation_InAppPurchase_Upgrade") }
      static var restoreText: String { return LocalizedString("Presentation_InAppPurchase_Restore_Text") }
      static var restoreLink: String { return LocalizedString("Presentation_InAppPurchase_Restore_Link") }

      struct BookmarksPage {
        static var image   = #imageLiteral(resourceName: "Image_InApp_Bookmarks")
        static var title:   String { return LocalizedString("Presentation_InAppPurchase_Bookmarks_Title") }
        static var caption: String { return LocalizedString("Presentation_InAppPurchase_Bookmarks_Content") }
      }

      struct ColorsPage {
        static var image   = #imageLiteral(resourceName: "Image_InApp_Colors")
        static var title:   String { return LocalizedString("Presentation_InAppPurchase_Colors_Title") }
        static var caption: String { return LocalizedString("Presentation_InAppPurchase_Colors_Content") }
      }
    }
  }

  struct Alerts {
    struct Location {
      struct Denied {
        static var title:    String { return LocalizedString("Alert_Denied_Title") }
        static var content:  String { return LocalizedString("Alert_Denied_Content") }
        static var settings: String { return LocalizedString("Alert_Denied_Settings") }
        static var ok:       String { return LocalizedString("Alert_Denied_Ok") }
      }

      struct DeniedGlobally {
        static var title:   String { return LocalizedString("Alert_GloballyDenied_Title") }
        static var content: String { return LocalizedString("Alert_GloballyDenied_Content") }
        static var ok:      String { return LocalizedString("Alert_GloballyDenied_Ok") }
      }
    }

    struct Bookmark {
      struct NoLinesSelected {
        static var title:   String { return LocalizedString("Alert_Bookmark_NoLinesSelected_Title") }
        static var content: String { return LocalizedString("Alert_Bookmark_NoLinesSelected_Content") }
        static var ok:      String { return LocalizedString("Alert_Bookmark_NoLinesSelected_Ok") }
      }

      struct NameInput {
        static var title:       String { return LocalizedString("Alert_Bookmark_NameInput_Title") }
        static var content:     String { return LocalizedString("Alert_Bookmark_NameInput_Content") }
        static var placeholder: String { return LocalizedString("Alert_Bookmark_NameInput_Placeholder") }
        static var cancel:      String { return LocalizedString("Alert_Bookmark_NameInput_Cancel") }
        static var save:        String { return LocalizedString("Alert_Bookmark_NameInput_Save") }
      }

      struct Instructions {
        static var title:   String { return LocalizedString("Alert_Bookmark_Instructions_Title") }
        static var content: String { return LocalizedString("Alert_Bookmark_Instructions_Content") }
        static var ok:      String { return LocalizedString("Alert_Bookmark_Instructions_Ok") }
      }
    }

    struct Network {
      struct NoInternet {
        static var title:    String { return LocalizedString("Alert_Network_NoInternet_Title") }
        static var content:  String { return LocalizedString("Alert_Network_NoInternet_Content") }
        static var tryAgain: String { return LocalizedString("Alert_Network_NoInternet_TryAgain") }
      }

      struct ConnectionError {
        static var title:    String { return LocalizedString("Alert_Network_ConnectionError_Title") }
        static var content:  String { return LocalizedString("Alert_Network_ConnectionError_Content") }
        static var tryAgain: String { return LocalizedString("Alert_Network_ConnectionError_TryAgain") }
      }
    }
  }

  struct App {
    struct Share {
      static var text:  String { return LocalizedString("Configuration_Share_Content") }
      static let image: UIImage = #imageLiteral(resourceName: "Image_Share")
    }
  }
}