import UIKit
import ReSwift
import WrocliveFramework
import PlaygroundSupport

AppEnvironment.push(.default)
Theme.setupAppearance()

let state = AppState.load(from: AppEnvironment.storage)
let middlewares = createMiddlewares()
let store = Store<AppState>(reducer: appReducer, state: state, middleware: middlewares)

let viewModel = MainViewModel(store)
let viewController = MainViewController(viewModel)

PlaygroundPage.current.liveView = viewController
