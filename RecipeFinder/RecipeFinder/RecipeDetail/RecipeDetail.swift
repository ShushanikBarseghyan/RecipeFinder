//
//  RecipeDetail.swift
//  RecipeFinder
//
//  Created by Shushanik Barseghyan on 18.12.24.
//

struct RecipeDetail: Decodable {
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let instructions: String?
    let image: String?
}
