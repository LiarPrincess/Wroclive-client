//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

//@objc
//func bookmarkButtonPressed() {
//  //    let selectedLines = self.linesSelector.selectedLines
//  //
//  //    guard selectedLines.any else {
//  //      BookmarkAlerts.showBookmarkNoLinesSelectedAlert(in: self)
//  //      return
//  //    }
//  //
//  //    BookmarkAlerts.showBookmarkNameInputAlert(in: self) { [weak self] name in
//  //      guard let name = name else { return }
//  //      let bookmark = Bookmark(name: name, lines: selectedLines)
//  //      Managers.bookmarks.addNew(bookmark)
//  //      self?.showBookmarkCreatedPopup()
//  //    }
//}

//private func showBookmarkCreatedPopup() {
//  let image   = StyleKit.drawStarFilledTemplateImage(size: Constants.BookmarksPopup.imageSize)
//  let title   = Localization.BookmarkAdded.title
//  let caption = Localization.BookmarkAdded.caption
//
//  let popup = PopupView(image: image, title: title, caption: caption)
//
//  self.view.addSubview(popup)
//  popup.snp.makeConstraints { make in
//    let centerOwner: ConstraintView = self.view.window ?? self.view
//    make.center.equalTo(centerOwner.snp.center)
//  }
//
//  let delay    = Constants.BookmarksPopup.delay
//  let duration = Constants.BookmarksPopup.duration
//
//  UIView.animateKeyframes(
//    withDuration: duration,
//    delay:        delay,
//    options:      [],
//    animations: {
//      UIView.addKeyframe(withRelativeStartTime: 0.00, relativeDuration: 0.00, animations: {
//        popup.alpha     = 0.0
//        popup.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//      })
//
//      // present
//      UIView.addKeyframe(withRelativeStartTime: 0.05, relativeDuration: 0.10, animations: {
//        popup.alpha = 0.5
//      })
//
//      UIView.addKeyframe(withRelativeStartTime: 0.05, relativeDuration: 0.10, animations: {
//        popup.alpha     = 1.0
//        popup.transform = CGAffineTransform.identity
//      })
//
//      // dismiss
//      UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.10, animations: {
//        popup.alpha     = 0.5
//        popup.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//      })
//
//      UIView.addKeyframe(withRelativeStartTime: 0.95, relativeDuration: 0.05, animations: {
//        popup.alpha = 0.0
//      })
//  },
//    completion: { _ in popup.removeFromSuperview() }
//  )
//}
