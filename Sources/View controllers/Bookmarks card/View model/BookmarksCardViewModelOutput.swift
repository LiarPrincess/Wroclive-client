//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BookmarksCardViewModelOutput {

  /**
   - from manager
   */
  var bookmarks: Driver<[BookmarksSection]> { get }

  /**
   - any self.bookmarks
   */
  var isTableViewVisible: Driver<Bool> { get }

  /**
   - no self.isTableViewVisible
   */
  var isPlaceholderVisible: Driver<Bool> { get }

  /**
   - change on input.editButtonPressed
   default: false
   */
  var isEditing: Driver<Bool> { get }

  /**
   - self.isEditing -> Edit
   - otherwise      -> Done
   */
  var editButtonText: Driver<NSAttributedString> { get }

  /**
   - input.itemSelected
   */
  var shouldClose: Driver<Void> { get }
}
