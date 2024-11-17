//
//  LoginViewController.swift
//  OnBoarding
//
//  Created by admin24 on 05/11/24.
//


import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "NoteShare"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = UIColor(red: 0.33, green: 0.49, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func createTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 25
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.leftViewMode = .always
        textField.isSecureTextEntry = isSecure
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    private lazy var emailTextField = createTextField(placeholder: "Enter your Email")
    private lazy var passwordTextField = createTextField(placeholder: "Enter your password", isSecure: true)
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(red: 0.33, green: 0.49, blue: 1.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signInWithAppleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(UIColor(red: 0.33, green: 0.49, blue: 1.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signUpPromptButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.gray
        ]
        
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            .foregroundColor: UIColor(red: 0.33, green: 0.49, blue: 1.0, alpha: 1.0)
        ]
        
        let attributedString = NSMutableAttributedString(string: "Don't have an account? ", attributes: regularAttributes)
        attributedString.append(NSAttributedString(string: "Sign Up", attributes: linkAttributes))
        
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews
        [logoLabel, emailTextField, passwordTextField,
         forgotPasswordButton, loginButton, signInWithAppleButton,
         signUpPromptButton].forEach { view.addSubview($0) }
        
        // Setup constraints
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 60),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signInWithAppleButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signInWithAppleButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signInWithAppleButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            signInWithAppleButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpPromptButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signUpPromptButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Add targets
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signInWithAppleButton.addTarget(self, action: #selector(signInWithAppleTapped), for: .touchUpInside)
        signUpPromptButton.addTarget(self, action: #selector(signUpPromptTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func loginTapped() {
        let collegeSelectionVC = CollegeSelectionViewController()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(collegeSelectionVC, animated: true)
    }
    
    @objc private func signInWithAppleTapped() {
        // Handle Sign in with Apple
    }
    
    @objc private func signUpPromptTapped() {
        let signUpVC = RegistrationViewController()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func forgotPasswordTapped() {
        // Handle forgot password
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
