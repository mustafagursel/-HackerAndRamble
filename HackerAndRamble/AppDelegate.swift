//
//  AppDelegate.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerDependencies()
        return true
    }

    // MARK: - Dependency registration

    func registerDependencies() {
        DependencyContainer.shared
            .register(TopStoriesViewModelProtocol.self) { TopStoriesViewModel() }
            .register(StoryDetailViewModelProtocol.self) { StoryDetailViewModel() }
            .register(HackerNewsApiProtocol.self) { HackerNewsApi() }
            .register(HackerNewsCacheProtocol.self) { HackerNewsCache() }
            .register(HackerNewsStoreProtocol.self) { HackerNewsStore() }
            .register(UserDefaults.self) { UserDefaults.standard }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

