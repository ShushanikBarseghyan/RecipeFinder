//
//  RecipeViewModel.swift
//  RecipeFinder
//
//  Created by Shushanik Barseghyan on 18.12.24.
//

import Combine
import SwiftUI

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = RecipeService()

    func searchRecipes(with ingredients: String) {
        isLoading = true
        errorMessage = nil
        service.searchRecipes(ingredients: ingredients) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
