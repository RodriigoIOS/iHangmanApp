//
//  ViewController.swift
//  iHangmanApp
//
//  Created by Rodrigo on 01/10/25.
//

import UIKit

// MARK: - Main View Controller
class IHangmanViewController: UIViewController {
    private let game = IHangmanGame()
    
    // UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "iRangman ⚽️"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hangmanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let keyboardContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let newGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Novo Jogo", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var letterButtons: [UIButton] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        game.startNewGame()
        updateUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(hangmanImageView)
        view.addSubview(wordLabel)
        view.addSubview(statusLabel)
        view.addSubview(keyboardContainer)
        view.addSubview(newGameButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hangmanImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            hangmanImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hangmanImageView.widthAnchor.constraint(equalToConstant: 150),
            hangmanImageView.heightAnchor.constraint(equalToConstant: 150),
            
            wordLabel.topAnchor.constraint(equalTo: hangmanImageView.bottomAnchor, constant: 30),
            wordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            wordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statusLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 15),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            keyboardContainer.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 30),
            keyboardContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            keyboardContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            keyboardContainer.heightAnchor.constraint(equalToConstant: 180),
            
            newGameButton.topAnchor.constraint(equalTo: keyboardContainer.bottomAnchor, constant: 20),
            newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newGameButton.widthAnchor.constraint(equalToConstant: 200),
            newGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        setupKeyboard()
        newGameButton.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
    }
    
    private func setupKeyboard() {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let rows = [
            Array("ABCDEFGHIJ"),
            Array("KLMNOPQRST"),
            Array("UVWXYZ")
        ]
        
        let buttonSize: CGFloat = 32
        let spacing: CGFloat = 4
        
        for (rowIndex, row) in rows.enumerated() {
            let rowView = UIStackView()
            rowView.axis = .horizontal
            rowView.spacing = spacing
            rowView.distribution = .fillEqually
            rowView.translatesAutoresizingMaskIntoConstraints = false
            
            for letter in row {
                let button = UIButton(type: .system)
                button.setTitle(String(letter), for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
                button.layer.cornerRadius = 6
                button.tag = Int(letter.asciiValue ?? 0)
                button.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
                
                rowView.addArrangedSubview(button)
                letterButtons.append(button)
            }
            
            keyboardContainer.addSubview(rowView)
            
            NSLayoutConstraint.activate([
                rowView.topAnchor.constraint(equalTo: keyboardContainer.topAnchor, constant: CGFloat(rowIndex) * (buttonSize + spacing)),
                rowView.centerXAnchor.constraint(equalTo: keyboardContainer.centerXAnchor),
                rowView.heightAnchor.constraint(equalToConstant: buttonSize)
            ])
        }
    }
    
    // MARK: - Actions
    @objc private func letterButtonTapped(_ sender: UIButton) {
        guard !game.isGameOver else { return }
        
        let letter = Character(UnicodeScalar(sender.tag)!)
        let correct = game.guessLetter(letter)
        
        sender.isEnabled = false
        sender.backgroundColor = correct ? .systemGreen : .systemRed
        
        updateUI()
        
        if game.isGameOver {
            showGameOverAlert()
        }
    }
    
    @objc private func startNewGame() {
        game.startNewGame()
        
        for button in letterButtons {
            button.isEnabled = true
            button.backgroundColor = .systemBlue
        }
        
        updateUI()
    }
    
    // MARK: - UI Updates
    private func updateUI() {
        wordLabel.text = game.displayWord
        statusLabel.text = "Erros: \(game.wrongGuesses)/\(game.maxWrongGuesses)"
        updateHangmanImage()
    }
    
    private func updateHangmanImage() {
        let imageName: String
        switch game.wrongGuesses {
        case 0: imageName = "figure.stand"
        case 1: imageName = "figure.walk"
        case 2: imageName = "figure.wave"
        case 3: imageName = "figure.fall"
        case 4: imageName = "figure.arms.open"
        case 5: imageName = "exclamationmark.triangle.fill"
        default: imageName = "xmark.circle.fill"
        }
        
        hangmanImageView.image = UIImage(systemName: imageName)
        hangmanImageView.tintColor = game.wrongGuesses >= game.maxWrongGuesses ? .systemRed : .systemOrange
    }
    
    private func showGameOverAlert() {
        let title = game.isGameWon ? "Parabéns! 🎉" : "Game Over 😔"
        let message = game.isGameWon
            ? "Você acertou a palavra!"
            : "A palavra era: \(game.currentWord)"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Novo Jogo", style: .default) { [weak self] _ in
            self?.startNewGame()
        })
        present(alert, animated: true)
    }
}
