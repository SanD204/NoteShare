import UIKit

// MARK: - User Detail View Controller
class UserDetailViewController: UIViewController {
    var userName: String = ""
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 120, weight: .regular)
        imageView.image = UIImage(systemName: "person.crop.circle.fill", withConfiguration: config)
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = userName
        nameLabel.text = userName
        
        [profileImageView, nameLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - User Cell
class UserCell: UICollectionViewCell {
    var onAvatarTapped: (() -> Void)?
    
    private let avatarButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.tintColor = .systemBlue
        
        let config = UIImage.SymbolConfiguration(pointSize: 90, weight: .regular)
        button.setImage(UIImage(systemName: "person.crop.circle.fill", withConfiguration: config), for: .normal)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [avatarButton, nameLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            avatarButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            avatarButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant: 90),
            avatarButton.heightAnchor.constraint(equalToConstant: 90),
            
            nameLabel.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupActions() {
        avatarButton.addTarget(self, action: #selector(avatarTapped), for: .touchUpInside)
    }
    
    @objc private func avatarTapped() {
        onAvatarTapped?()
    }
    
    func configure(with name: String) {
        nameLabel.text = name
    }
}

// MARK: - Main View Controller
class SharedWithMeViewController: UIViewController {
    // MARK: - UI Components
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let homeLabel: UILabel = {
        let label = UILabel()
//        label.text = "Home"
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.showsSearchResultsButton = false
        return searchBar
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shared with me"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private lazy var usersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: "UserCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Data
    private let users = ["Rehmat Singh", "Vardhan", "Sanyog", "Yadu", "Awnish"]
    private var filteredUsers: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
        setupActions()
        filteredUsers = users
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
//        navigationController?.navigationBar.isHidden = true
        
        [backButton, homeLabel, searchBar, titleLabel, usersCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            homeLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            homeLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            
            searchBar.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            usersCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            usersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            usersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            usersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        
    }
    
//    private func handleAvatarTap(for index: Int) {
//        let detailVC = SharedNotesViewController()
//
//        let userName = filteredUsers[index].replacingOccurrences(of: ".", with: "")
//
//        if let titleLabel = detailVC.view.viewWithTag(100) as? UILabel {
//            titleLabel.text = "Shared by \(userName)"
//        }
    private func handleAvatarTap(for index: Int) {
        let detailVC = SharedNotesViewController()
        let selectedUserName = filteredUsers[index]
        detailVC.username = selectedUserName
        navigationController?.pushViewController(detailVC, animated: true)
    }
        
//        navigationController?.pushViewController(detailVC, animated: true)
    }


// MARK: - Collection View Delegate & DataSource
extension SharedWithMeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.configure(with: filteredUsers[indexPath.item])
        
        cell.onAvatarTapped = { [weak self] in
            self?.handleAvatarTap(for: indexPath.item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 40) / 3
        return CGSize(width: width, height: width + 10)
    }
}

// MARK: - SearchBar Delegate
extension SharedWithMeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        usersCollectionView.reloadData()
    }
}
#Preview() {
    SharedWithMeViewController()
}
