//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol Coordinator: class {
  var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
  func addChildCoordinator(_ coordinator: Coordinator) {
    self.childCoordinators.append(coordinator)
  }

  func removeChildCoordinator(_ coordinator: Coordinator) {
    if let index = self.childCoordinators.index(where: { $0 === coordinator }) {
      childCoordinators.remove(at: index)
    }
  }
}
