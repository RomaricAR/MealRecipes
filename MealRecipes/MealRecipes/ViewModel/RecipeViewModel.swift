//
//  File.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/2/24.
//  Copyright © 2024 Romaric Allahramadji. All rights reserved. 
//

import Foundation
import Combine


class RecipeViewModel: ObservableObject {
   // Published properties that will be observed for changes
    @Published var recipes: [RecipeModel] = []
    @Published var recipeDetails: [RecipeDetailsModel] = []
    @Published var recipeId = ""
    var cancellables = Set<AnyCancellable>()
    
    var networkService: NetworkService
    
    var urlString: String = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    var recipeDetailsUrlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?"
    
    //For Unit Test purposes only
    var constructedURL = ""
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        getRecipes()
    }

    //For Unit Testing purposes only
    func getMockRecipes() {
        networkService.getMockRecipes { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let recipesResponse = try decoder.decode(RecipeResponse.self, from: data)
                    self.recipes = recipesResponse.meals
                } catch {
                    print("Error decoding recipes data: \(error)")
                    self.recipes = []
                }
            case .failure(let error):
                print("Error during network request: \(error)")
                self.recipes = []
            }
        }
    }
    
    
    func getRecipes() {
        guard let url = URL(string: urlString) else { return }
   
        NetworkingManager.download(url: url)
        // Decode the JSON response
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
        // Filter out meals with null or empty values
            .map { recipeResponse in
                let filteredRecipes = recipeResponse.meals.filter { meal in
                    return !(meal.recipeName.isEmpty || meal.recipeImageURL.isEmpty || meal.recipeId.isEmpty)
                }
                return RecipeResponse(meals: filteredRecipes)
            }
        // Handle completion
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedRecipes in
                self?.recipes = returnedRecipes.meals
            })
        // Store the cancellable reference
            .store(in: &cancellables)
    }
    
    
    func getRecipeDetails(id: String) {
        // Construct the URL with the recipe ID
        guard let url = URL(string: "\(recipeDetailsUrlString)i=\(id)") else { return }
        
        //For Unit Test purposes only
        constructedURL = String(url.description)
        
        performRecipeDetailsRequest(url: url)
    }
    
    func performRecipeDetailsRequest(url: URL) {
        NetworkingManager.download(url: url)
            .decode(type: RecipeDetailsResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedRecipeDetails) in
                if let recipeDetails = returnedRecipeDetails.meal {
                    // Append the transformed or original data to your array
                    self?.recipeDetails.append(recipeDetails)
                }
            })
            .store(in: &cancellables)
    }
}
