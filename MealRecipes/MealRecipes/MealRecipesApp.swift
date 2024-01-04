//
//  MealRecipesApp.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/2/24.
//

import SwiftUI

@main
struct MealRecipesApp: App {
    @StateObject var recipeViewModel = RecipeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RecipesView()
                    .environmentObject(recipeViewModel)
            }
        }
    }
}
