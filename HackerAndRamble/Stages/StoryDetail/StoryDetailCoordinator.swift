//
//  StoryDetailCoordinator.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import UIKit

class StoryDetailCoordinator: Coordinator {
    let navigationController: UINavigationController
    let hackerNewsId: Int

    init(navigationController: UINavigationController, hackerNewsId: Int) {
        self.navigationController = navigationController
        self.hackerNewsId = hackerNewsId
    }

    func start() {
        let storyDetailViewController = StoryDetailViewController()
        storyDetailViewController.hackerNewsId = hackerNewsId
        navigationController.pushViewController(storyDetailViewController, animated: true)
    }
}
