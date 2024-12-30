//
//  Recipe.swift
//  RecipeFinder
//
//  Created by Shushanik Barseghyan on 18.12.24.
//

struct Recipe: Identifiable, Decodable {
    let id: Int
    let title: String
    let image: String?
}
