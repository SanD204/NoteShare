import UIKit

class ProfileViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Profile"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .systemGray5
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "ABC"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "abc@icloud.com"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let educationLabel: UILabel = {
        let label = UILabel()
        label.text = "BTech CSE 3rd Year"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let institutionLabel: UILabel = {
        let label = UILabel()
        label.text = "SRM Institute of Science and Technology"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let myDownloadsLabel: UILabel = {
        let label = UILabel()
        label.text = "My Downloads"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.backgroundColor = .systemGray6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let accountSettingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Account Settings"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signOutButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Sign Out"
        config.baseForegroundColor = .red
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.contentHorizontalAlignment = .left
        return button
    }()

    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Changes", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews in proper hierarchy
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add all main subviews to content view
        [titleLabel, profileContainer, myDownloadsLabel, optionsStackView,
         accountSettingsLabel, signOutButton, saveButton].forEach { contentView.addSubview($0) }
        
        // Add profile container subviews
        [profileImageView, nameLabel, emailLabel, educationLabel, institutionLabel]
            .forEach { profileContainer.addSubview($0) }
        
        // Create option rows
        let options = [
            ("Downloads", "arrow.down.circle.fill"),
            ("My Notes", "note.text"),
            ("Updates", "gear")
        ]
        
        options.forEach { title, image in
            let optionView = createOptionRow(title: title, imageName: image)
            optionsStackView.addArrangedSubview(optionView)
        }
        
        // Setup constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            profileContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            profileContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            profileImageView.topAnchor.constraint(equalTo: profileContainer.topAnchor, constant: 24),
            profileImageView.centerXAnchor.constraint(equalTo: profileContainer.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor, constant: -16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor, constant: -16),
            
            educationLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            educationLabel.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor, constant: 16),
            educationLabel.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor, constant: -16),
            
            institutionLabel.topAnchor.constraint(equalTo: educationLabel.bottomAnchor, constant: 8),
            institutionLabel.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor, constant: 16),
            institutionLabel.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor, constant: -16),
            institutionLabel.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor, constant: -24),
            
            myDownloadsLabel.topAnchor.constraint(equalTo: profileContainer.bottomAnchor, constant: 32),
            myDownloadsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            optionsStackView.topAnchor.constraint(equalTo: myDownloadsLabel.bottomAnchor, constant: 16),
            optionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            accountSettingsLabel.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor, constant: 32),
            accountSettingsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            signOutButton.topAnchor.constraint(equalTo: accountSettingsLabel.bottomAnchor, constant: 16),
            signOutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            signOutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 44),
            
            saveButton.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func createOptionRow(title: String, imageName: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: imageName)
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronImageView = UIImageView()
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .systemGray3
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(imageView)
        containerView.addSubview(label)
        containerView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 44),
            
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        return containerView
    }
}

#Preview(){
    ProfileViewController()
}
