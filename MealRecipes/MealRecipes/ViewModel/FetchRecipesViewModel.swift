//
//  File.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/2/24.
//

import Foundation
import Combine


class FetchRecipesViewModel: ObservableObject {
   // Published properties that will be observed for changes
    @Published var recipes: [RecipeModel] = []
    @Published var recipeDetails: [RecipeDetailsModel] = []
    @Published var recipeId = ""
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getRecipes()
    }
    
    
    
    func getRecipes() {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
        //Creates Publisher and for this case it is automatically subscribed to a background thread
        URLSession.shared.dataTaskPublisher(for: url)
        //Receive on the main thread
            .receive(on: DispatchQueue.main)
        //Check to see if the data is good
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
        // Decode the JSON response
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
        // Filter out meals with null or empty values
            .map { recipeResponse in
                let filteredRecipes = recipeResponse.meals.filter { meal in
                    return !(meal.strMeal.isEmpty || meal.strMealThumb.isEmpty || meal.idMeal.isEmpty)
                }
                return RecipeResponse(meals: filteredRecipes)
            }
        // Handle completion
            .sink { (completion) in
                print("Completion: \(completion)")
            } 
        // Handle received value
            receiveValue: { [weak self] (returnedRecipes) in
                self?.recipes = returnedRecipes.meals
            }
        // Store the cancellable reference
            .store(in: &cancellables)
    }
    
    func getRecipeDetails(id: String) {
        // URL for the API endpoint
        guard let recipeDetailsUrl = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?") else { return }
        
        // Construct the URL with the recipe ID
        guard let urlString = URL(string: "\(recipeDetailsUrl)i=\(id)") else { return }
        
        performRequest(url: urlString)
    }
    
    func performRequest(url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: RecipeDetailsResponse.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("Completed: \(completion)")
            } receiveValue: { [weak self] (returnedRecipeDetails) in
                if let recipeDetails = returnedRecipeDetails.meal {
                         // Append the transformed or original data to your array
                         self?.recipeDetails.append(recipeDetails)
                     }
                
            }
            .store(in: &cancellables)
    }
}
