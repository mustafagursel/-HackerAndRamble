//
//  TopStoriesCoordinator.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import UIKit

class TopStoriesCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = TopStoriesViewController()
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension TopStoriesCoordinator: TopStoriesViewControllerDelegate {
    func didStoryDetailRequested(with hackerNewsId: Int) {
        let storyDetailCoordinator = StoryDetailCoordinator(navigationController: navigationController, hackerNewsId: hackerNewsId)
        storyDetailCoordinator.start()
    }
}
