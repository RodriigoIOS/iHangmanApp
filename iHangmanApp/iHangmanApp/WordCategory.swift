//
//  WordCategory.swift
//  iHangmanApp
//
//  Created by Rodrigo on 02/10/25.
//

import Foundation

// MARK: - Word Category Model
struct WordCategory: Codable {
    let nome: String
    let icone: String
    let palavras: [String]
}

// MARK: - Categories Container
struct CategoriesContainer: Codable {
    let categorias: [WordCategory]
}
