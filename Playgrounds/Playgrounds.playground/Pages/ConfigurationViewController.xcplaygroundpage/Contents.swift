//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
@testable import Radar_Framework

// Mockups

// Environment
let environment = Environment()
AppEnvironment.push(environment)

Managers.theme.applyColorScheme()

// Live
let viewController = ConfigurationViewController()
PlaygroundPage.current.liveView = viewController
