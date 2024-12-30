//
//  RecipeListView.swift
//  RecipeFinder
//
//  Created by Shushanik Barseghyan on 17.12.24.
//

import SwiftUI
import Combine


struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var ingredients = ""
    @State private var showingErrorAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Enter comma-separated list of ingredients you have in your fridge, and we'll suggest a list of recipes to you \nHappy cooking!")
                    .multilineTextAlignment(.leading)
                
                TextField("Type here", text: $ingredients)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Search Recipes") {
                    viewModel.searchRecipes(with: ingredients)
                    if viewModel.errorMessage != nil {
                        showingErrorAlert = true
                    }
                }
                .disabled(ingredients.isEmpty)
                .buttonStyle(.borderedProminent)
                .foregroundStyle(Color.white)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                .padding(.horizontal)
                .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                        dismissButton: .default(Text("OK")) {
                            viewModel.errorMessage = nil
                        }
                    )
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    List(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            HStack {
                                LoadedImage(url: recipe.image ?? "")
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Text(recipe.title)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Recipe Finder")
        }
    }
}

#Preview {
    RecipeListView()
}
