//
//  RecipeManager.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/2/24.
//

import Foundation

struct MealModel: Identifiable, Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var id: String {
        idMeal
    }
}

struct MealResponse: Codable {
    let meals: [MealModel]
}

