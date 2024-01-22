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
    
    func test_RecipeViewModel_GetRecipes_ShouldNotBeEmpty() {
        // Given
        let viewModel = RecipeViewModel(networkService: MockNetworkService())
        let expectation = self.expectation(description: "Recipes loaded successfully")

        // When
        viewModel.getMockRecipes()

        // Then
        XCTAssertFalse(viewModel.recipes.allSatisfy { $0.recipeName.isEmpty && $0.recipeName.isEmpty && $0.recipeId.isEmpty })
            expectation.fulfill()
 
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func test_RecipeViewModel_GetRecipes_ShouldBESupportedUrl() {
        // Given
        let viewModel = RecipeViewModel(networkService: MockNetworkService())
        let expectation = self.expectation(description: "Should be a supported URL")
        
        // When
        viewModel.getMockRecipes()
        
        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertTrue(!viewModel.recipes.isEmpty)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func test_RecipeViewModel_GetRecipes_UrlShouldNotBeInvalid() {
        // Given
        let viewModel = RecipeViewModel(networkService: MockNetworkService())
        viewModel.urlString = "invalid_url"
        let expectation = self.expectation(description: "Invalid URL")
        
        // When
        viewModel.getRecipes()
        
        //Then
        XCTAssertTrue(viewModel.recipes.isEmpty)
        
        expectation.fulfill()
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func test_RecipeViewModel_GetRecipes_ShouldHandleCancellationCorrectly() {
        // Given
        let viewModel = RecipeViewModel(networkService: MockNetworkService())
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

    func test_RecipeViewModel_GetRecipeDetails_ShouldConstructUrlProperly() {
        // Given
        let viewModel = RecipeViewModel(networkService: MockNetworkService())
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
