//
//  RecipeManager.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/2/24.
//

import Foundation

struct RecipeModel: Identifiable, Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    // Computed property to conform to Identifiable protocol
    var id: String {
        idMeal
    }
}

// A model for the response from the recipe details API
struct RecipeDetailsModel: Identifiable, Codable {
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    let idMeal: String

    let strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10: String
    let strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20: String?

    let strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10: String?
    let strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20: String?

    // Ingredients for the meal (up to 20)
    var ingredients: [String] {
        return [strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20].compactMap { $0?.isEmpty == false ? $0 : nil }
    }

    // Measurements for the ingredients (up to 20)
    var measures: [String] {
        return [strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20].compactMap { $0?.isEmpty == false ? $0 : nil }
    }

    var id: String {
        idMeal
    }
}

struct RecipeDetailsResponse: Codable {
    let meals: [RecipeDetailsModel]
    
    var meal: RecipeDetailsModel? {
        return meals.first
    }
}

struct RecipeResponse: Codable {
    let meals: [RecipeModel]
}

