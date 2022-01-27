//
//  Log.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import Foundation

func log<T>(_ message: T, function: String = #function) {
    #if DEBUG
        if let text = message as? String {
            print("\(function): \(text)")
        }
    #endif
}
