//
//  MealRecipesTests.swift
//  MealRecipesTests
//
//  Created by Romaric Allahramadji on 1/7/24.
//  Copyright © 2024 Romaric Allahramadji. All rights reserved. 
//


import XCTest
@testable import MealRecipes

final class RecipeViewModel_Tests: XCTestCase {
    
    func test_RecipeViewModel_GetRecipes_IsNotEmpty() {
        // Given
        let viewModel = RecipeViewModel()
        let expectation = self.expectation(description: "Recipes loaded")

        // When
        viewModel.getRecipes()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertTrue(viewModel.recipes.allSatisfy { !$0.strMeal.isEmpty && !$0.strMealThumb.isEmpty && !$0.idMeal.isEmpty })
           
            expectation.fulfill()
        }
        viewModel.recipes = []
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func test_RecipeViewModel_GetRecipes_InvalidURL() {
        // Given
        let viewModel = RecipeViewModel()
        viewModel.urlString = "invalid_url"
        let expectation = self.expectation(description: "Invalid URL")
        
        // When
        viewModel.getRecipes()
        
        //Then
        XCTAssertTrue(viewModel.recipes.isEmpty)
        
        expectation.fulfill()
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func test_RecipeViewModel_GetRecipes_Cancellation() {
        // Given
        let viewModel = RecipeViewModel()
        let expectation = self.expectation(description: "Cancellation")

        // When
        viewModel.getRecipes()
        viewModel.cancellables.forEach { $0.cancel() }

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertTrue(viewModel.recipes.isEmpty)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func test_RecipeViewModel_GetRecipeDetails_URLConstructionAndDetailsRetrieval() {
        // Given
        let viewModel = RecipeViewModel()
        let validID = "52893"
        let expectedURL = URL(string: "\(viewModel.recipeDetailsUrlString)i=\(validID)")
        let expectation = self.expectation(description: "Details Retrieval")
        //When
        viewModel.getRecipeDetails(id: validID)

        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // Assert URL construction
            XCTAssertEqual(viewModel.constructedURL, String(expectedURL!.description), "URL is not constructed correctly")

            // Assert recipe details retrieval
            XCTAssertTrue(!viewModel.recipeDetails.isEmpty, "Recipe details are not retrieved")
            
            expectation.fulfill()
        }    
        waitForExpectations(timeout: 5, handler: nil)
    }
}
