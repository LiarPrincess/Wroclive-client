# Wroclive - Real-time public transport in Wrocław

This repository contains sources of [Wroclive iOS app](https://www.wroclive.app).

(Psst… server code is also [open-sourced](https://github.com/LiarPrincess/Wroclive-server)!)

## About

Moving around Wrocław has suddenly become much easier!

Wroclive allows you to check the current location of public transport vehicles.
This will help you decide whether it is worth rushing to a stop or to calmly finish your coffee.

If you are only interested in specific lines, you can use our filtering functionality. You can also save the most frequently used connections for easier access.

With Wroclive you will never miss your bus!

![AppStore screenshots](https://raw.githubusercontent.com/LiarPrincess/Wroclive-client/main/Design/GitHub/appstore_screens.png)

## Source map

- [Design](Design) - graphic assets

  - Icon - as `.svg` and `png`.

  - [Design](Design/Images) - all of the button/toolbar images. Use `.svg` files to edit and then export to pdf ([Boxy SVG](https://boxy-svg.com) is an amazing tool for this).

  - [AppStore images](Design/AppStore\ images) - AppStore screenshots (before and after framing). Requires [fastlane](https://fastlane.tools).

- [Wroclive](Wroclive) - iOS app. This dir contains only `AppDelegate.swift` and application icon, everything else is in `WrocliveFramework`.

- [WrocliveFramework](WrocliveFramework) - most of the Wroclive code. We use separate framework, so that our unit tests execute much faster (because now there is no need to launch the whole app).

  - [Api](WrocliveFramework/Api) - code to interact with [wroclive.app](https://www.wroclive.app) api. DO NOT create new instances, use the one from `Environment`.

  - [Assets](WrocliveFramework/Assets) - translations and images from `Design/Images`. DO NOT use directly! We use [SwiftGen](https://github.com/SwiftGen/SwiftGen) to generate static types (see `Generated` directory).

  - [Coordinators](WrocliveFramework/Coordinators) - app navigation extracted from view controllers. There are a lot of good tutorials about this on the internet.

  - [Environment](WrocliveFramework/Environment) - `Environment` contains wrappers for Apple frameworks, so we can mock them during unit tests (so basically a dependency injection). Most of the time we inject `Environment` in `init` (we do not use global `AppEnvironment` like [kickstarter/ios-oss](https://github.com/kickstarter/ios-oss)).

  - [Extensions](WrocliveFramework/Extensions)

  - [Generated](WrocliveFramework/Generated) - code generated by [SwiftGen](https://github.com/SwiftGen/SwiftGen) from our `Assets`. Use `make gen` to regenerate.

  - [Helpers](WrocliveFramework/Helpers) - code that did not fit anywhere else.

    - [Card panel](WrocliveFramework/Helpers/Card\ panel) - card is a container view controller that pops from the bottom of the screen. Most of our views (for example: lines, bookmarks and settings) are presented in cards.

    - [MapUpdateScheduler.swift](WrocliveFramework/Helpers/MapUpdateScheduler.swift) - every 5 seconds it will dispatch `ApiMiddlewareActions.requestVehicleLocations` to update vehicle loctions on the map.

    - [DispatchStoreUpdatesFromAppleFrameworks.swift](WrocliveFramework/Helpers/DispatchStoreUpdatesFromAppleFrameworks.swift) - will observe Apple frameworks and dispatch actions to update `AppState`. For example: after user granted location authorization it will dispatch `UserLocationAuthorizationAction.set(authorization)` action.

  - [Models](WrocliveFramework/Models) - main data structures (for example: `Line`, `Vehicle`, `Bookmark`).

  - [Redux](WrocliveFramework/Redux) - code connected to [ReSwift](https://github.com/ReSwift/ReSwift). It contains `AppState` struct that describes the state of the whole application. You should also check `Actions` and `Middleware`.

  - [Theme](WrocliveFramework/Theme) - color scheme, fonts and text attributes.

  - [View controllers](WrocliveFramework/View\ controllers) - basically our views. We use `ViewModels` for testability. We also prefer [SnapKit](https://github.com/SnapKit/SnapKit) over storyboards.

    - [Main](WrocliveFramework/View\ controllers/Main) - main view, basically `MapViewController` + toolbar.

    - [Map](WrocliveFramework/View\ controllers/Map) - view controller responsible for map (duh…), nested in `MainViewController`.

    - [Bookmarks card](WrocliveFramework/View\ controllers/Bookmarks\ card) - view controller to manage bookmarks (heart icon on main toolbar)

    - [Search card](WrocliveFramework/View\ controllers/Search\ card) - view controller to select lines and create bookmarks (yes, the name is bad, but it is too much work to change it now).

    - [Settings card](WrocliveFramework/View\ controllers/Settings\ card) - app settings

- [WrocliveTests](WrocliveTests) - unit/snapshot tests

  - [\_\_Snapshots\_\_](WrocliveTests/__Snapshots__) - snapshots made by [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing).

## Recommended reading order

If you are new to the app, then following reading order is recommended:

1. [Wroclive/AppDelegate.swift](Wroclive/AppDelegate.swift) - although, you do not need to understand everything
2. [WrocliveFramework/Models](WrocliveFramework/Models)
3. [WrocliveFramework/Environment](WrocliveFramework/Environment)
4. [WrocliveFramework/Redux](WrocliveFramework/Redux)
5. View controller of your choice ([BookmarksCard](WrocliveFramework/View%20controllers/Bookmarks%20card) is the simplest one)

## Tooling

Before contributing to Wroclive you may want too read about following tools:

- [ReSwift](https://github.com/ReSwift/ReSwift) - we use it to manage `AppState`, whatever you do in code you will probably have to interact with it!
- [mxcl/PromiseKit](https://github.com/mxcl/PromiseKit) - async tool of our choice, used mostly for network request (but not only).
- [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) - we use it in our unit tests. Check out our [__Snapshots__](WrocliveTests/__Snapshots__) directory!
- Make - the most important command is `make gen` to generate [SwiftGen](https://github.com/SwiftGen/SwiftGen) files in  (`WrocliveFramework/Generated`)
- [SwiftGen](https://github.com/SwiftGen/SwiftGen)
- [SwiftLint](https://github.com/realm/SwiftLint)

## Special thanks

Special thanks to the maintainers of the following libraries:
- [ReSwift](https://github.com/ReSwift/ReSwift) - Unidirectional Data Flow in Swift - Inspired by Redux
- [SnapKit](https://github.com/SnapKit/SnapKit) - A Swift Autolayout DSL for iOS & OS X
- [mxcl/PromiseKit](https://github.com/mxcl/PromiseKit) - Promises for Swift & ObjC
- [Alamofire](https://github.com/Alamofire/Alamofire) - Elegant HTTP Networking in Swift
- [ivanvorobei/SPAlert](https://github.com/IvanVorobei/SPAlert) - Native alert from Apple Music & Feedback. Contains Done, Heart & Message and other presets
- [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) - Delightful Swift snapshot testing
- [fastlane](https://fastlane.tools) - App automation done right
- [SwiftGen](https://github.com/SwiftGen/SwiftGen) - The Swift code generator for your assets, storyboards, Localizable.strings, … — Get rid of all String-based APIs!
- [realm/SwiftLint](https://github.com/realm/SwiftLint) - A tool to enforce Swift style and conventions

## License

Wroclive is licensed under the Mozilla Public License 2.0 license.
See [LICENSE](LICENSE) for more information.
