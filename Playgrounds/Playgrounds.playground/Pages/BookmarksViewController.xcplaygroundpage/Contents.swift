//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
@testable import Radar_Framework

// Mockups
let bookmarksManager = BookmarksManagerScreenshot()

// Environment
let environment = Environment(bookmarks: bookmarksManager)
AppEnvironment.push(environment)

Managers.theme.applyColorScheme()

// Live
let viewController = BookmarksViewController(delegate: nil)
PlaygroundPage.current.liveView = viewController
