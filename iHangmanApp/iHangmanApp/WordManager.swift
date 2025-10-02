//
//  WordManager.swift
//  iHangmanApp
//
//  Created by Rodrigo on 02/10/25.
//

import Foundation

// MARK: - Word Manager
class WordManager {
    static let shared = WordManager()
    
    private var categories: [WordCategory] = []
    private var currentCategory: WordCategory?
    
    private init() {
        loadWords()
    }
    
    // MARK: - Public Methods
    func loadWords() {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("❌ Erro: Não foi possível encontrar o arquivo words.json")
            loadDefaultWords()
            return
        }
        
        do {
            let container = try JSONDecoder().decode(CategoriesContainer.self, from: data)
            self.categories = container.categorias
            self.currentCategory = categories.first
            print("✅ Carregadas \(categories.count) categorias com \(getTotalWordsCount()) palavras")
        } catch {
            print("❌ Erro ao decodificar JSON: \(error)")
            loadDefaultWords()
        }
    }
    
    func getRandomWord() -> String {
        guard let category = currentCategory,
              !category.palavras.isEmpty else {
            return "PALMEIRAS" // Fallback
        }
        return category.palavras.randomElement() ?? "PALMEIRAS"
    }
    
    func getRandomWord(from categoryName: String) -> String {
        let category = categories.first { $0.nome == categoryName }
        return category?.palavras.randomElement() ?? getRandomWord()
    }
    
    func getAllCategories() -> [WordCategory] {
        return categories
    }
    
    func getCurrentCategory() -> WordCategory? {
        return currentCategory
    }
    
    func setCurrentCategory(_ categoryName: String) {
        if let category = categories.first(where: { $0.nome == categoryName }) {
            currentCategory = category
        }
    }
    
    func setRandomCategory() {
        currentCategory = categories.randomElement()
    }
    
    func getTotalWordsCount() -> Int {
        return categories.reduce(0) { $0 + $1.palavras.count }
    }
    
    // MARK: - Private Methods
    private func loadDefaultWords() {
        // Fallback para as palavras originais caso o JSON falhe
        let defaultCategory = WordCategory(
            nome: "Futebol Brasileiro",
            icone: "⚽️",
            palavras: [
                "PALMEIRAS", "FLAMENGO", "CORINTHIANS", "SAO PAULO",
                "SANTOS", "VASCO", "CRUZEIRO", "ATLETICO MINEIRO",
                "GREMIO", "INTERNACIONAL", "BOTAFOGO", "FLUMINENSE",
                "NEYMAR", "PELE", "ROMARIO", "RONALDO", "RIVALDO"
            ]
        )
        
        self.categories = [defaultCategory]
        self.currentCategory = defaultCategory
        print("⚠️ Usando palavras padrão como fallback")
    }
}
