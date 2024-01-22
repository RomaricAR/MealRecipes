//
//  RecipeManager.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/2/24.
//  Copyright © 2024 Romaric Allahramadji. All rights reserved.
//

import Foundation

struct RecipeModel: Codable, Identifiable {
    let recipeName: String
    let recipeImageURL: String
    let recipeId: String
    
    // Computed property to conform to Identifiable protocol
    var id: String {
        recipeId
    }
    enum CodingKeys: String, CodingKey {
        case recipeName = "strMeal"
        case recipeImageURL = "strMealThumb"
        case recipeId = "idMeal"
    }
}

// A model for the response from the recipe details API
struct RecipeDetailsModel: Identifiable, Codable {
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    let idMeal: String

    let ingredients: [String]
    let measures: [String]

    var id: String {
        idMeal
    }

    enum CodingKeys: String, CodingKey {
        case strMeal, strInstructions, strMealThumb, idMeal
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        idMeal = try container.decode(String.self, forKey: .idMeal)

        // Dynamically decode ingredients and measures
        var dynamicIngredients: [String] = []
        var dynamicMeasures: [String] = []

        let containerDic = try decoder.singleValueContainer()
        let recipeDic = try containerDic.decode([String: String?].self)
        

        var index = 1
        while true {
            let ingredientKey = "strIngredient\(index)"
            let measureKey = "strMeasure\(index)"
            if let ingredientKey = recipeDic[ingredientKey] as? String,
               let measureKey = recipeDic[measureKey] as? String {
                if !ingredientKey.isEmpty {
                    dynamicIngredients.append(ingredientKey)
                    dynamicMeasures.append(measureKey)
                }
            } else {
                // If we can't find an ingredient or measure for the current index, break the loop
                print("Can't find an ingredient or measure for the current index")
                break
            }
            index += 1
        }
        ingredients = dynamicIngredients
        measures = dynamicMeasures
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

