//
//  MealRecipesTests.swift
//  MealRecipesTests
//
//  Created by Romaric Allahramadji on 1/7/24.
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



}
