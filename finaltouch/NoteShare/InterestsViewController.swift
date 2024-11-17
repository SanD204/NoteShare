import UIKit

class InterestsViewController: UIViewController {
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image, for: .normal)
        button.setTitle("Back", for: .normal)
        button.tintColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        // Add this line to ensure proper image positioning
        button.semanticContentAttribute = .forceLeftToRight
        // Add this line to set the spacing between image and text
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose your Interests"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select the topics you'd like to explore"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let interestsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let interests = [
        // Core Computer Science
        "Mathematics",
        "Algorithms",
        "Data Structures",
        "Computer Architecture",
        "Operating Systems",
        "Networking",
        "Database Systems",
        "System Design",
        
        // Programming Languages
        "Python",
        "Java",
        "C++",
        "JavaScript",
        "Swift",
        "Rust",
        "Go",
        "TypeScript",
        
        // AI & ML
        "Artificial Intelligence",
        "Machine Learning",
        "Deep Learning",
        "Natural Language Processing",
        "Computer Vision",
        "Reinforcement Learning",
        "LLMs",
        "Neural Networks",
        
        // Web & Mobile
        "Web Development",
        "Mobile Development",
        "Frontend",
        "Backend",
        "UI/UX Design",
        "DevOps",
        "Cloud Computing",
        
        // Mathematics & Theory
        "Calculus",
        "Linear Algebra",
        "Statistics",
        "Probability",
        "Discrete Mathematics",
        "Graph Theory",
        "Automata Theory",
        
        // Emerging Tech
        "Blockchain",
        "Cybersecurity",
        "IoT",
        "AR/VR",
        "Quantum Computing",
        "Edge Computing",
        "Robotics"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBackButton()
        
    }
    
    private func setupBackButton() {
        // First ensure the button exists and is a subview
        guard backButton.superview == nil else { return }
        
        // First add the button to the view hierarchy
        view.addSubview(backButton)
        
        // Only after adding to view hierarchy, activate constraints
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(scrollView)
        view.addSubview(continueButton)
        
        scrollView.addSubview(interestsContainer)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20),
            
            interestsContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            interestsContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            interestsContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            interestsContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            interestsContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            

        ])
       
        createInterestButtons()
    }
    
    private func createInterestButtons() {
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        let spacing: CGFloat = 10
        var maxHeight: CGFloat = 0
        
        for interest in interests {
            let button = createInterestButton(withTitle: interest)
            let buttonWidth = button.intrinsicContentSize.width + 20
            
            if currentX + buttonWidth > (view.bounds.width - 40) {
                currentX = 0
                currentY += 40 + spacing
            }
            
            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: 40)
            interestsContainer.addSubview(button)
            
            currentX += buttonWidth + spacing
            maxHeight = currentY + 40
        }
        
        let containerHeight = maxHeight + 40
        interestsContainer.heightAnchor.constraint(equalToConstant: containerHeight).isActive = true
    }
    
    private func createInterestButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(interestButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func interestButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.backgroundColor = sender.isSelected ? .systemBlue : .systemGray6
        sender.setTitleColor(sender.isSelected ? .white : .systemBlue, for: .normal)
    }
    
    @objc private func continueButtonTapped() {
        // Handle continue action
        print("Continue button tapped")
    }
}

#Preview {
    InterestsViewController()
}
