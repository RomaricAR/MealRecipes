//
//  RecipesView.swift
//  MealRecipes
//
//  Created by Romaric Allahramadji on 1/2/24.
//

import SwiftUI

struct RecipesView: View {
    @StateObject var fetchData = FetchRecipesViewModel()
    
    let columns = [GridItem(.fixed(180)),
                   GridItem(.fixed(180))
                ]
    
    var body: some View {
        ZStack {
            Color("Peach").ignoresSafeArea()
            
            VStack {
                Text("Recipes")
                    .font(.largeTitle)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(fetchData.meals) { meal in
                            AsyncImage(url: URL(string: String(meal.strMealThumb))) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .shadow(radius: 15)
                                    .overlay(alignment: .bottom) {
                                        Text(meal.strMeal)
                                            .foregroundStyle(.white)
                                            .shadow(color: .black, radius: 5)
                                            .font(.headline)
                                            .frame(maxWidth: 180)
                                            .padding(.bottom, 5)
                                    }
                                
                            } placeholder: {
                                //Placeholder for when image is still loading
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 180)
                                    .overlay(alignment: .bottom) {
                                        Text(meal.strMeal)
                                            .foregroundStyle(.white)
                                            .font(.headline)
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
}
