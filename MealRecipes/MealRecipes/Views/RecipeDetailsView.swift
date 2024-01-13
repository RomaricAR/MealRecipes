//
//  ContentView.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/2/24.
//  Copyright © 2024 Romaric Allahramadji. All rights reserved.
//

import SwiftUI

struct RecipeDetailsView: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel

    var body: some View {
        ZStack {
            Color("Cream").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // Check if there are any recipe details
                    if let details = recipeViewModel.recipeDetails.first {
                        Text(details.strMeal)
                            .font(.title)
                            .foregroundStyle(Color("Peach"))
                        AsyncImage(url: URL(string: String(details.strMealThumb))) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .frame(width: 320)
                                .shadow(radius: 5)
                        } placeholder: {
                            //Placeholder for when image is still loading
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 167)
                        }
                        Text("Instructions")
                            .font(.system(size: 22))
                            .foregroundStyle(Color("Peach"))
                            .padding(.top)
       
                        Text(details.strInstructions)
                            .font(.system(size: 18))
                            .foregroundStyle(Color("Retro"))
                        
                        Text("Ingredients/Measurements")
                            .font(.system(size: 22))
                            .foregroundStyle(Color("Peach"))
                            .padding(.top)
                        
                        // Pair each ingredient with its measurement
                        let ingredientPairs = Array(zip(details.ingredients, details.measures))
                        let uniquePairs = ingredientPairs.enumerated().map { index, pair in
                            return (id: "\(index)-\(pair.0)-\(pair.1)", pair: pair)
                        }

                        // Display each ingredient and its measurement
                        ForEach(uniquePairs, id: \.id) { item in
                            HStack {
                                Text("\(item.pair.0):")
                                Text(" \(item.pair.1)")
                            }.foregroundStyle(Color("Retro"))
                             .font(.system(size: 18))
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }.onDisappear {
            // Clear the recipe details when the view disappears
            recipeViewModel.recipeDetails = []
        }
    }
}


#Preview {
    RecipeDetailsView()
        .environmentObject(RecipeViewModel())
}
