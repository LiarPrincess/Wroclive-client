//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

class StorageManager: StorageManagerType {

  private var _bookmarks:       [Bookmark]?
  private var _searchCardState: SearchCardState?
  private let _fileSystem     = FileSystem()

  // MARK: - StorageManagerType

  var bookmarks: [Bookmark] {
    if self._bookmarks == nil {
      self._bookmarks = self.readDocument(.bookmarks) as? [Bookmark]
    }
    return self._bookmarks ?? []
  }

  var searchCardState: SearchCardState {
    if self._searchCardState == nil {
      self._searchCardState = self.readDocument(.searchCardState) as? SearchCardState
    }
    return self._searchCardState ?? SearchCardState(page: .tram, selectedLines: [])
  }

  func saveBookmarks(_ bookmarks: [Bookmark]) {
    self._bookmarks = bookmarks
    self.writeDocument(.bookmarks(value: bookmarks))
  }

  func saveSearchCardState(_ state: SearchCardState) {
    self._searchCardState = state
    self.writeDocument(.searchCardState(value: state))
  }

  // MARK: - Document manager helpers

  private func readDocument(_ document: Document) -> Any? {
    return self._fileSystem.read(document)
  }

  private func writeDocument(_ document: DocumentData) {
    self._fileSystem.write(document)
  }
}
