import UIKit
import ReSwift
import WrocliveFramework
import PlaygroundSupport

AppEnvironment.push(.default)
Theme.setupAppearance()

let state = loadPreviousState()
let store = Store<AppState>(reducer: appReducer, state: state, middleware: [])

let viewModel = MainViewModel(store)
let viewController = MainViewController(viewModel)

PlaygroundPage.current.liveView = viewController
