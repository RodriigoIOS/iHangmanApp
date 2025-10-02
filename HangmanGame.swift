// MARK: - Game Model
class HangmanGame {
    private let words = [
        "PALMEIRAS", "FLAMENGO", "CORINTHIANS", "SAO PAULO",
        "SANTOS", "VASCO", "CRUZEIRO", "ATLETICO MINEIRO",
        "GREMIO", "INTERNACIONAL", "BOTAFOGO", "FLUMINENSE",
        "NEYMAR", "PELE", "ROMARIO", "RONALDO", "RIVALDO"
    ]
    
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
        currentWord = words.randomElement() ?? "PALMEIRAS"
        guessedLetters.removeAll()
        wrongGuesses = 0
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