//
//  DependencyContainer.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import Foundation

typealias FactoryClosure = () -> AnyObject

protocol DependencyContainerProtocol {
    @discardableResult
    func register<Dependency>(_ type: Dependency.Type, factory: @escaping FactoryClosure) -> DependencyContainerProtocol
    func resolve<Dependency>(_ type: Dependency.Type) -> Dependency?
}

final class DependencyContainer: DependencyContainerProtocol {
    static var shared: DependencyContainerProtocol = DependencyContainer()
    private var services = [String: FactoryClosure]()

    private init() {}

    @discardableResult
    func register<Dependency>(_ type: Dependency.Type,
                              factory: @escaping FactoryClosure) -> DependencyContainerProtocol {
        services["\(type)"] = factory
        return DependencyContainer.shared
    }

    func resolve<Dependency>(_ type: Dependency.Type) -> Dependency? {
        return services["\(type)"]?() as? Dependency
    }
}

@propertyWrapper
struct Injected<Dependency> {
    var dependency: Dependency!

    var wrappedValue: Dependency {
        mutating get {
            if dependency == nil {
                dependency = DependencyContainer.shared.resolve(Dependency.self)
                guard dependency != nil else {
                    fatalError("Unresolved dependency: \(Dependency.self)")
                }
            }
            return dependency
        }

        set {
            dependency = newValue
        }
    }
}
