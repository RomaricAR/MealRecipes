//
//  MealRecipesApp.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/2/24.
//

import SwiftUI

@main
struct MealRecipesApp: App {
    @StateObject var recipesViewModel = FetchRecipesViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RecipesView()
                    .environmentObject(recipesViewModel)
            }
        }
    }
}
