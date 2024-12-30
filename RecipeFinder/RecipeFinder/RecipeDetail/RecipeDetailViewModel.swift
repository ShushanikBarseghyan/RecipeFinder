//
//  RecipeDetailViewModel.swift
//  RecipeFinder
//
//  Created by Shushanik Barseghyan on 18.12.24.
//

import Combine
import SwiftUI

class RecipeDetailViewModel: ObservableObject {
    @Published var details: RecipeDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = RecipeService()

    func fetchDetails(for recipeID: Int) {
        isLoading = true
        errorMessage = nil
        service.fetchRecipeDetails(id: recipeID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let details):
                    self?.details = details
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
