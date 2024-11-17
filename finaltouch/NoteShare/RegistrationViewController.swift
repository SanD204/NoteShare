import UIKit
import AuthenticationServices

class RegistrationViewController: UIViewController {
    
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
    
    private lazy var nameTextField = createTextField(placeholder: "Enter your Name")
    private lazy var emailTextField = createTextField(placeholder: "Enter your Email")
    private lazy var passwordTextField = createTextField(placeholder: "Choose a password", isSecure: true)
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
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
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.gray
        ]
        
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(red: 0.33, green: 0.49, blue: 1.0, alpha: 1.0)
        ]
        
        let attributedString = NSMutableAttributedString(string: "By tapping Register you agree to our\n", attributes: regularAttributes)
        attributedString.append(NSAttributedString(string: "Terms of Use", attributes: linkAttributes))
        attributedString.append(NSAttributedString(string: " and ", attributes: regularAttributes))
        attributedString.append(NSAttributedString(string: "Privacy Policy", attributes: linkAttributes))
        
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    
    
    private let loginPromptButton: UIButton = {
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
        
        let attributedString = NSMutableAttributedString(string: "Have an account? ", attributes: regularAttributes)
        attributedString.append(NSAttributedString(string: "Login", attributes: linkAttributes))
        
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
        [logoLabel, nameTextField, emailTextField, passwordTextField,
         registerButton, signInWithAppleButton, termsLabel, loginPromptButton].forEach { view.addSubview($0) }
        
        // Setup constraints
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 60),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
            registerButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            
            signInWithAppleButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16),
            signInWithAppleButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            signInWithAppleButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            signInWithAppleButton.heightAnchor.constraint(equalToConstant: 50),
            
            termsLabel.topAnchor.constraint(equalTo: signInWithAppleButton.bottomAnchor, constant: 24),
            termsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            termsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            loginPromptButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loginPromptButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Add targets
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        signInWithAppleButton.addTarget(self, action: #selector(signInWithAppleTapped), for: .touchUpInside)
        loginPromptButton.addTarget(self, action: #selector(loginPromptTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
       
    }
    
    // MARK: - Actions
    @objc private func registerTapped() {
        // Handle registration logic
        let collegeSelectionVC = CollegeSelectionViewController()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(collegeSelectionVC, animated: true)
    }
    
    @objc private func signInWithAppleTapped() {
        // Handle Sign in with Apple
    }
    
    @objc private func loginPromptTapped() {
        
        let loginVC = LoginViewController()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

}
