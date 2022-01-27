//
//  MainCoordinator.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import UIKit

class MainCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let coordinator = TopStoriesCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
