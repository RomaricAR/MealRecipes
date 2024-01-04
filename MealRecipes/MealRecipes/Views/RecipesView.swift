//
//  RecipesView.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/2/24.
//

import SwiftUI

// View for displaying a list of recipes
struct RecipesView: View {
    // Access the shared FetchRecipesViewModel instance
    @EnvironmentObject var recipesViewModel: FetchRecipesViewModel
    @State var recipeIsSelected = false
    @State private var selectedRecipe: RecipeModel? = nil
    @State private var viewID = UUID()
    
    // Define the layout for the grid
    let columns = [GridItem(.fixed(180)),
                   GridItem(.fixed(180))
                    ]
    
    var body: some View {
        ZStack {
            // Set the background color
            Color("Cream").ignoresSafeArea()
            VStack {
                Text("Recipes")
                    .font(.largeTitle)
                    .foregroundStyle(Color("Retro"))
                ScrollView {
                    // Create a grid with lazy loading
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(recipesViewModel.recipes) { recipe in
                            // Load and display the recipe image
                            AsyncImage(url: URL(string: String(recipe.strMealThumb))) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .shadow(radius: 5)
                                    .overlay(alignment: .bottom) {
                                        // Display the recipe name at the bottom of the image
                                        Text(recipe.strMeal)
                                            .foregroundStyle(Color("Retro"))
                                            .shadow(color: .black, radius: 5)
                                            .font(.headline)
                                            .frame(maxWidth: 176)
                                            .padding(.bottom, 5)
                                    }
                            } placeholder: {
                                // Placeholder for when image is still loading
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 167)
                                    .overlay(alignment: .bottom) {
                                        // Display the recipe name at the bottom of the placeholder
                                        Text(recipe.strMeal)
                                            .foregroundStyle(Color("Retro"))
                                            .font(.headline)
                                            .shadow(color: .black, radius: 5)
                                            .frame(maxWidth: 160)
                                    }
                            }
                            // Handle tap gesture
                            .onTapGesture {
                                recipesViewModel.getRecipeDetails(id: recipe.id)
                                recipeIsSelected = true
                            }.navigationDestination(isPresented: $recipeIsSelected) {
                                // Navigate to the RecipeDetailsView when a recipe is selected
                                RecipeDetailsView()
                                    .environmentObject(recipesViewModel)
                                    .onDisappear {
                                        // Generate a new UUID when the view disappears
                                        viewID = UUID()
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RecipesView()
        .environmentObject(FetchRecipesViewModel())
}
