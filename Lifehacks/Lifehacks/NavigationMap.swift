//
//  NavigationMap.swift
//  Lifehacks
//
//  Created by Qasim Al Mahammedi on 1/10/23.
//

import SwiftUI

struct NavigationMap {
    var destinationForQuestion: ((Question) -> QuestionView)?
    var destinationForUser: ((User) -> ProfileView)?
}

extension NavigationMap {
    struct Key: EnvironmentKey {
        static let defaultValue = NavigationMap()
    }
}

extension EnvironmentValues {
    var navigationMap: NavigationMap {
        get { self[NavigationMap.Key.self] }
        set { self[NavigationMap.Key.self] = newValue  }
    }
}

