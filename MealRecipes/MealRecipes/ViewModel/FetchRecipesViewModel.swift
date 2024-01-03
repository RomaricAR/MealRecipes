//
//  File.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/2/24.
//

import Foundation
import Combine


class FetchRecipesViewModel: ObservableObject {
    @Published var meals: [MealModel] = []
    @Published var recipeIsSelected = false
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
            .decode(type: MealResponse.self, decoder: JSONDecoder())
            .map { mealResponse in
                // Filter out meals with null or empty values
                let filteredMeals = mealResponse.meals.filter { meal in
                    return !(meal.strMeal.isEmpty || meal.strMealThumb.isEmpty || meal.idMeal.isEmpty)
                }
                return MealResponse(meals: filteredMeals)
            }
            .sink { (completion) in
                print("Completed: \(completion)")
            } receiveValue: { [weak self] (returnedMeals) in
                self?.meals = returnedMeals.meals
            }
            .store(in: &cancellables)
    }
    
    func getRecipeDetails(id: String) {
        guard let recipeDetailsUrl = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772") else { return }
        
        guard let urlString = URL(string: "\(recipeDetailsUrl)i=\(id)") else { return }
        
        performRequest(url: urlString)
    }
    
    func performRequest(url: URL) {
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
            .decode(type: MealResponse.self, decoder: JSONDecoder())
            .map { mealResponse in
                // Filter out meals with null or empty values
                let filteredMeals = mealResponse.meals.filter { meal in
                    return !(meal.strMeal.isEmpty || meal.strMealThumb.isEmpty || meal.idMeal.isEmpty)
                }
                return MealResponse(meals: filteredMeals)
            }
            .sink { (completion) in
                print("Completed: \(completion)")
            } receiveValue: { [weak self] (returnedMeals) in
                self?.meals = returnedMeals.meals
            }
            .store(in: &cancellables)
    }
}
