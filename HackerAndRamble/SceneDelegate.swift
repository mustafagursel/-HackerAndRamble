//
//  SceneDelegate.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let appCoordinator = MainCoordinator(navigationController: navigationController)
        coordinator = appCoordinator
        appCoordinator.start()

        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
    }
}
