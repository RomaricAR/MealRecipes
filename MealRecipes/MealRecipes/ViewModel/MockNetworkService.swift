//
//  MockNetworkService.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/16/24.
//

import SwiftUI

protocol NetworkService {
    func getMockRecipes(completion: @escaping (Result<Data, Error>) -> Void)
}

class MockNetworkService: NetworkService {
    func getMockRecipes(completion: @escaping (Result<Data, Error>) -> Void) {
        let testData = """
        {"meals":[{"strMeal":"TestMeal1","strMealThumb":"testImage1","idMeal":"1"},
                   {"strMeal":"TestMeal2","strMealThumb":"testImage2","idMeal":"2"}]}
        """.data(using: .utf8)!
        completion(.success(testData))
    }
}
