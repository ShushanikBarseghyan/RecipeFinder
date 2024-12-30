//
//  Service.swift
//  RecipeFinder
//
//  Created by Shushanik Barseghyan on 18.12.24.
//

import SwiftUI

class RecipeService {
    private let apiKey = "6626a96c54794ee289e534e421726306"
    private let baseURL = "https://api.spoonacular.com/recipes"

    func searchRecipes(ingredients: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let query = "\(baseURL)/findByIngredients?ingredients=\(ingredients)&number=10&apiKey=\(apiKey)"
        guard let url = URL(string: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                completion(.success(recipes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchRecipeDetails(id: Int, completion: @escaping (Result<RecipeDetail, Error>) -> Void) {
        let query = "\(baseURL)/\(id)/information?apiKey=\(apiKey)"
        guard let url = URL(string: query) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            do {
                let details = try JSONDecoder().decode(RecipeDetail.self, from: data)
                completion(.success(details))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
