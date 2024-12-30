//
//  RecipeDetailView.swift
//  RecipeFinder
//
//  Created by Shushanik Barseghyan on 18.12.24.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @StateObject private var viewModel = RecipeDetailViewModel()
    @State private var showingErrorAlert = false
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let details = viewModel.details {
                    Text(details.title)
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .padding()
                    
                    if let _ = recipe.image {
                        LoadedImage(
                            url: recipe.image ?? ""
                        )
                        .padding(20)
                        .frame(maxWidth: .infinity)
                    }
                    
                    HStack {
                        if details.servings < 6 {
                            ForEach(0..<details.servings, id: \.self) { _ in
                                Image(systemName: "fork.knife.circle")
                            }
                        } else {
                            Text("\(details.servings)")
                        }
                        Text("Servings")
                        
                    }
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                    .padding()
                    
                    HStack {
                        Image(systemName: "timer")
                        Text("Ready in \(details.readyInMinutes) minutes")
                    }
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                    
                    if let instructions = details.instructions {
                        Text(formatHTMLString(instructions))
                            .padding()
                    } else {
                        Text("No instructions available")
                            .italic()
                            .padding()
                    }
                } else if viewModel.errorMessage != nil {
                    Spacer()
                    Text("Failed to load details")
                        .foregroundColor(.red)
                        .padding()
                }
                Text("Bon Appétit!")
                    .font(.callout)
                    .foregroundColor(.accentColor)
                    .padding(.bottom)
            }
            .onAppear {
                viewModel.fetchDetails(for: recipe.id)
                if viewModel.errorMessage != nil {
                    showingErrorAlert = true
                }
            }
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK")) {
                        viewModel.errorMessage = nil
                    }
                )
            }
        }
    }
    
    private func formatHTMLString(_ html: String) -> String {
        let formatted = html
            .replacingOccurrences(of: "<li>", with: "• ")
            .replacingOccurrences(of: "</li>", with: "\n\n")
            .replacingOccurrences(of: "<ol>", with: "")
            .replacingOccurrences(of: "</ol>", with: "\n\n")
            .replacingOccurrences(of: "<p>", with: "")
            .replacingOccurrences(of: "</p>", with: "\n\n")
        return formatted
    }
}

