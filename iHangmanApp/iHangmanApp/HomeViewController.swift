//
//  HomeViewController.swift
//  iHangmanApp
//
//  Created by Rodrigo on 03/10/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    // UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "iHangman"
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "🎯 Adivinhe a palavra!"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🎮 Jogar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let hangmanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "figure.stand")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemOrange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(hangmanImageView)
        view.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hangmanImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            hangmanImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hangmanImageView.widthAnchor.constraint(equalToConstant: 200),
            hangmanImageView.heightAnchor.constraint(equalToConstant: 200),
            
            playButton.topAnchor.constraint(equalTo: hangmanImageView.bottomAnchor, constant: 60),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 200),
            playButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupActions() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func playButtonTapped() {
        let categorySelectionVC = CategorySelectionViewController()
        let navigationController = UINavigationController(rootViewController: categorySelectionVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
