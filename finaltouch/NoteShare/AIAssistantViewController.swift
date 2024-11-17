//  AIAssistantViewController.swift


import UIKit

class AIAssistantViewController: UIViewController {
    // Header buttons
    private let menuButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        button.setImage(UIImage(systemName: "tray.and.arrow.down.fill", withConfiguration: config), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    private let getPlusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Plus ✦", for: .normal)
        button.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 1.0, alpha: 1.0)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 15
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
        return button
    }()
    
    private let composeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: config), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    // Center logo
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill") // Example of a different system image
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let messageContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()

    private let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Message"
        field.font = .systemFont(ofSize: 16)
        field.backgroundColor = .clear
        return field
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let micButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 21, weight: .medium)
        button.setImage(UIImage(systemName: "mic.fill", withConfiguration: config), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let voiceChatButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        button.setImage(UIImage(systemName: "waveform", withConfiguration: config), for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 20
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createMessageOptions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        [menuButton, getPlusButton, composeButton, logoImageView,
         messageContainerStackView, inputContainer, voiceChatButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Add input container subviews
        [textField, addButton, micButton].forEach {
            inputContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Header elements
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            menuButton.widthAnchor.constraint(equalToConstant: 44),
            menuButton.heightAnchor.constraint(equalToConstant: 44),
            
            getPlusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getPlusButton.centerYAnchor.constraint(equalTo: menuButton.centerYAnchor),
            
            composeButton.topAnchor.constraint(equalTo: menuButton.topAnchor),
            composeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            composeButton.widthAnchor.constraint(equalToConstant: 44),
            composeButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Center logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Message options container
            messageContainerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageContainerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            messageContainerStackView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: -16),
            
            // Input container
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: 60),
            
            // Add button
            addButton.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 16),
            addButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Text field
            textField.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: micButton.leadingAnchor, constant: -8),
            textField.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            
            // Mic button constraints
            // Voice chat button constraints (far right)
            voiceChatButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -16),
            voiceChatButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            voiceChatButton.widthAnchor.constraint(equalToConstant: 40),
            voiceChatButton.heightAnchor.constraint(equalToConstant: 40),

            // Mic button constraints (to the left of voiceChatButton)
            micButton.trailingAnchor.constraint(equalTo: voiceChatButton.leadingAnchor, constant: -8),
            micButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            micButton.widthAnchor.constraint(equalToConstant: 30),
            micButton.heightAnchor.constraint(equalToConstant: 30)


        ])
        
        // Add targets for voice buttons
        micButton.addTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
        voiceChatButton.addTarget(self, action: #selector(voiceChatButtonTapped), for: .touchUpInside)
    }
    
    private func createMessageOptions() {
        let options = [
            ("Create a cartoon", "illustration of my pet"),
            ("Summarize a long document", "that I'm going to send to you")
        ]
        
        options.forEach { title, subtitle in
            let containerView = createMessageOptionView(title: title, subtitle: subtitle)
            messageContainerStackView.addArrangedSubview(containerView)
        }
    }
    
    private func createMessageOptionView(title: String, subtitle: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 12
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = .gray
        
        [titleLabel, subtitleLabel].forEach { stackView.addArrangedSubview($0) }
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(messageOptionTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
        
        return containerView
    }
    
    @objc private func messageOptionTapped() {
        print("Message option tapped")
    }
    
    @objc private func micButtonTapped() {
        print("Microphone button tapped")
        // Implement voice recording functionality
    }
    
    @objc private func voiceChatButtonTapped() {
        print("Voice chat button tapped")
        // Implement voice chat functionality
    }
}
#Preview(){
    AIAssistantViewController()
}

//import UIKit
//
//class AIAssistantViewController: UIViewController {
//    // MARK: - UI Components
//    
//    private let headerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBackground
//        return view
//    }()
//    
//    private let aiStatusView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 1.0, alpha: 1.0)
//        view.layer.cornerRadius = 25
//        return view
//    }()
//    
//    private let statusDot: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemGreen
//        view.layer.cornerRadius = 4
//        return view
//    }()
//    
//    private let statusLabel: UILabel = {
//        let label = UILabel()
//        label.text = "AI Ready"
//        label.font = .systemFont(ofSize: 14, weight: .medium)
//        label.textColor = .darkGray
//        return label
//    }()
//    
//    private let featuredCardsScrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.showsHorizontalScrollIndicator = false
//        return scrollView
//    }()
//    
//    private let cardsStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 15
//        stack.distribution = .fillEqually
//        return stack
//    }()
//    
//    private let promptCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 15
//        layout.minimumInteritemSpacing = 15
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = .clear
//        cv.register(PromptCell.self, forCellWithReuseIdentifier: "PromptCell")
//        return cv
//    }()
//    
//    private let inputContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBackground
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.1
//        view.layer.shadowOffset = CGSize(width: 0, height: -2)
//        view.layer.shadowRadius = 10
//        return view
//    }()
//    
//    private let inputField: UITextField = {
//        let field = UITextField()
//        field.placeholder = "Ask anything..."
//        field.font = .systemFont(ofSize: 16)
//        field.backgroundColor = .systemGray6
//        field.layer.cornerRadius = 20
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
//        field.leftViewMode = .always
//        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
//        field.rightViewMode = .always
//        return field
//    }()
//    
//    private let sendButton: UIButton = {
//        let button = UIButton()
//        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
//        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: config)?
//            .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
//        button.setImage(image, for: .normal)
//        return button
//    }()
//    
//    // MARK: - Lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupConstraints()
//        setupPromptCollectionView()
//        createFeaturedCards()
//    }
//    
//    // MARK: - Setup Methods
//    
//    private func setupUI() {
//        view.backgroundColor = .systemBackground
//        
//        [headerView, featuredCardsScrollView, promptCollectionView, inputContainerView].forEach {
//            view.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
//        
//        [aiStatusView].forEach {
//            headerView.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
//        
//        [statusDot, statusLabel].forEach {
//            aiStatusView.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
//        
//        featuredCardsScrollView.addSubview(cardsStackView)
//        cardsStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        [inputField, sendButton].forEach {
//            inputContainerView.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Header
//            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            headerView.heightAnchor.constraint(equalToConstant: 60),
//            
//            // AI Status
//            aiStatusView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
//            aiStatusView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
//            aiStatusView.widthAnchor.constraint(equalToConstant: 100),
//            aiStatusView.heightAnchor.constraint(equalToConstant: 50),
//            
//            statusDot.centerYAnchor.constraint(equalTo: aiStatusView.centerYAnchor),
//            statusDot.leadingAnchor.constraint(equalTo: aiStatusView.leadingAnchor, constant: 15),
//            statusDot.widthAnchor.constraint(equalToConstant: 8),
//            statusDot.heightAnchor.constraint(equalToConstant: 8),
//            
//            statusLabel.centerYAnchor.constraint(equalTo: aiStatusView.centerYAnchor),
//            statusLabel.leadingAnchor.constraint(equalTo: statusDot.trailingAnchor, constant: 8),
//            
//            // Featured Cards
//            featuredCardsScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
//            featuredCardsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            featuredCardsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            featuredCardsScrollView.heightAnchor.constraint(equalToConstant: 180),
//            
//            cardsStackView.topAnchor.constraint(equalTo: featuredCardsScrollView.topAnchor),
//            cardsStackView.leadingAnchor.constraint(equalTo: featuredCardsScrollView.leadingAnchor, constant: 20),
//            cardsStackView.trailingAnchor.constraint(equalTo: featuredCardsScrollView.trailingAnchor, constant: -20),
//            cardsStackView.bottomAnchor.constraint(equalTo: featuredCardsScrollView.bottomAnchor),
//            cardsStackView.heightAnchor.constraint(equalTo: featuredCardsScrollView.heightAnchor),
//            
//            // Prompt Collection
//            promptCollectionView.topAnchor.constraint(equalTo: featuredCardsScrollView.bottomAnchor, constant: 20),
//            promptCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            promptCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            promptCollectionView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),
//            
//            // Input Container
//            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            inputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            inputContainerView.heightAnchor.constraint(equalToConstant: 80),
//            
//            inputField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 20),
//            inputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
//            inputField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
//            inputField.heightAnchor.constraint(equalToConstant: 40),
//            
//            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -20),
//            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
//            sendButton.widthAnchor.constraint(equalToConstant: 40),
//            sendButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
//    }
//    
//    private func createFeaturedCards() {
//        let cardTitles = ["Image Generation", "Code Assistant", "Writing Helper"]
//        let cardIcons = ["wand.and.stars", "chevron.left.forwardslash.chevron.right", "text.word.spacing"]
//        
//        for i in 0..<3 {
//            let cardView = createFeatureCard(title: cardTitles[i], icon: cardIcons[i])
//            cardsStackView.addArrangedSubview(cardView)
//            
//            NSLayoutConstraint.activate([
//                cardView.widthAnchor.constraint(equalToConstant: 150)
//            ])
//        }
//    }
//    
//    private func createFeatureCard(title: String, icon: String) -> UIView {
//        let cardView = UIView()
//        cardView.backgroundColor = .systemIndigo
//        cardView.layer.cornerRadius = 15
//        
//        let iconImageView = UIImageView()
//        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
//        iconImageView.image = UIImage(systemName: icon, withConfiguration: config)
//        iconImageView.tintColor = .white
//        iconImageView.contentMode = .scaleAspectFit
//        
//        let titleLabel = UILabel()
//        titleLabel.text = title
//        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
//        titleLabel.textColor = .white
//        titleLabel.numberOfLines = 0
//        
//        [iconImageView, titleLabel].forEach {
//            cardView.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
//        
//        NSLayoutConstraint.activate([
//            iconImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
//            iconImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
//            iconImageView.widthAnchor.constraint(equalToConstant: 40),
//            iconImageView.heightAnchor.constraint(equalToConstant: 40),
//            
//            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
//            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
//        ])
//        
//        return cardView
//    }
//    
//    private func setupPromptCollectionView() {
//        promptCollectionView.delegate = self
//        promptCollectionView.dataSource = self
//    }
//}
//
//// MARK: - Collection View Delegate & DataSource
//extension AIAssistantViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 6 // Example number of prompt suggestions
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromptCell", for: indexPath) as! PromptCell
//        let prompts = ["Write a story", "Analyze data", "Translate text", "Explain concept", "Debug code", "Summarize article"]
//        cell.configure(with: prompts[indexPath.item])
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.bounds.width - 15) / 2
//        return CGSize(width: width, height: 60)
//    }
//}
//
//// MARK: - Prompt Cell
//class PromptCell: UICollectionViewCell {
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 14, weight: .medium)
//        label.textColor = .darkGray
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setup() {
//        backgroundColor = .systemGray6
//        layer.cornerRadius = 12
//        
//        addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//    
//    func configure(with title: String) {
//        titleLabel.text = title
//    }
//}
//
//#Preview {
//    AIAssistantViewController()
//}
