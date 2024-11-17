//
//  ViewController.swift
//  OnBoarding
//
//  Created by admin24 on 02/11/24.
//

import UIKit

class LandingViewController: UIViewController {
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "NoteShare"
        label.font = .systemFont(ofSize: 60, weight: .bold)
        label.textColor = UIColor(red: 0.33, green: 0.49, blue: 1.0, alpha: 1.0) // Blue color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Handwritten Knowledge, Shared Together"
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private lazy var getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.backgroundColor = UIColor(red: 0.33, green: 0.49, blue: 1.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(logoLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(getStartedButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Logo constraints
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            
            // Subtitle constraints
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // Button constraints
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            getStartedButton.widthAnchor.constraint(equalToConstant: 350),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        // Add button target
        getStartedButton.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
    }
    
    @objc private func getStartedTapped() {
        let registrationVC = FeaturesViewController()
        // If you want to show the navigation bar for this transition
        registrationVC.navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(registrationVC, animated: true)
    }
}

#Preview{
    LandingViewController()
}
