//
//  IHangmanGame.swift
//  iHangmanApp
//
//  Created by Rodrigo on 01/10/25.
//

// MARK: - Game Model
class IHangmanGame {
    private let wordManager = WordManager.shared
    
    private(set) var currentWord: String = ""
    private(set) var guessedLetters: Set<Character> = []
    private(set) var wrongGuesses: Int = 0
    let maxWrongGuesses = 6
    
    var displayWord: String {
        currentWord.map { guessedLetters.contains($0) || $0 == " " ? String($0) : "_" }.joined(separator: " ")
    }
    
    var isGameWon: Bool {
        currentWord.allSatisfy { $0 == " " || guessedLetters.contains($0) }
    }
    
    var isGameOver: Bool {
        isGameWon || wrongGuesses >= maxWrongGuesses
    }
    
    func startNewGame() {
        currentWord = wordManager.getRandomWord()
        guessedLetters.removeAll()
        wrongGuesses = 0
    }
    
    func startNewGame(category: String) {
        wordManager.setCurrentCategory(category)
        currentWord = wordManager.getRandomWord()
        guessedLetters.removeAll()
        wrongGuesses = 0
    }
    
    func getCurrentCategory() -> WordCategory? {
        return wordManager.getCurrentCategory()
    }
    
    func getAllCategories() -> [WordCategory] {
        return wordManager.getAllCategories()
    }
    
    func guessLetter(_ letter: Character) -> Bool {
        guard !guessedLetters.contains(letter) else { return false }
        guessedLetters.insert(letter)
        
        if !currentWord.contains(letter) {
            wrongGuesses += 1
            return false
        }
        return true
    }
}
