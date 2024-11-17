
import UIKit

class FavouriteViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Notes"
        label.backgroundColor = .systemGray6
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let moreOptionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var collectionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Collections"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(collectionsLabelTapped))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private let navigateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let favouritesLabel: UILabel = {
        let label = UILabel()
        label.text = "Favourites"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var favouritesCollectionView: UICollectionView?
    
    private let noteCards: [NoteCard] = [
            NoteCard(
                title: "iOS Development",
                author: "By Sanyog",
                description: "Take a deep dive into the world of iOS",
                pdfUrl: Bundle.main.url(forResource: "test", withExtension: "pdf")!,
                coverImage: UIImage(named: "ios")
            ),
            NoteCard(
                title: "Physics Concepts",
                author: "By Raj",
                description: "Fundamental Physics Concepts Explained",
                pdfUrl: Bundle.main.url(forResource: "test", withExtension: "pdf")!,
                coverImage: UIImage(named: "physics")
            ),
            NoteCard(
                title: "Chemistry Lab Report",
                author: "By Sai",
                description: "Detailed Lab Report on Chemical Reactions",
                pdfUrl: Bundle.main.url(forResource: "test", withExtension: "pdf")!,
                coverImage: UIImage(named: "chem")
            ),
            NoteCard(
                title: "Trigonometry",
                author: "By Raj",
                description: "Advanced Trigonometry Practices and Types",
                pdfUrl: Bundle.main.url(forResource: "test", withExtension: "pdf")!,
                coverImage: UIImage(named: "math1")
            ),
            NoteCard(
                title: "DM Notes",
                author: "By Sanyog",
                description: "Discrete Mathematics with the advanced concepts",
                pdfUrl: Bundle.main.url(forResource: "test", withExtension: "pdf")!,
                coverImage: UIImage(named: "math2")
            )
        ]
    
    override func viewDidLoad() {
           super.viewDidLoad()
           setupUI()
           setupCollectionView()
           setupTableView()
           configureNavigationBar()
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           configureNavigationBar()
       }
       
       private func configureNavigationBar() {
           // Hide the navigation bar for this view controller
           navigationController?.setNavigationBarHidden(true, animated: false)
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Show the navigation bar again when leaving this view
           navigationController?.setNavigationBarHidden(false, animated: false)
       }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
    
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // Add buttons
        view.addSubview(addNoteButton)
        view.addSubview(moreOptionsButton)
        NSLayoutConstraint.activate([
            addNoteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addNoteButton.trailingAnchor.constraint(equalTo: moreOptionsButton.leadingAnchor, constant: -16),
            
            moreOptionsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            moreOptionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // Add search bar
        view.addSubview(searchBar)
        searchBar.delegate = self
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Add collections section
        view.addSubview(collectionsLabel)
        view.addSubview(navigateButton)
        navigateButton.addTarget(self, action: #selector(navigateToDetailPage), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            collectionsLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            collectionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            navigateButton.centerYAnchor.constraint(equalTo: collectionsLabel.centerYAnchor),
            navigateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // Add favourites section
        view.addSubview(favouritesLabel)
        NSLayoutConstraint.activate([
            favouritesLabel.topAnchor.constraint(equalTo: collectionsLabel.bottomAnchor, constant: 40),
            favouritesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // Setup button actions
        addNoteButton.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
        moreOptionsButton.addTarget(self, action: #selector(moreOptionsTapped), for: .touchUpInside)
        //        addNoteButton.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
        //        moreOptionsButton.addTarget(self, action: #selector(moreOptionsTapped), for: .touchUpInside)
        
        
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        
        favouritesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        favouritesCollectionView?.delegate = self
        favouritesCollectionView?.dataSource = self
        favouritesCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        favouritesCollectionView?.register(NoteCardCell.self, forCellWithReuseIdentifier: NoteCardCell.identifier)
        favouritesCollectionView?.backgroundColor = .clear
        
        guard let favouritesCollectionView = favouritesCollectionView else { return }
        
        view.addSubview(favouritesCollectionView)
        NSLayoutConstraint.activate([
            favouritesCollectionView.topAnchor.constraint(equalTo: favouritesLabel.bottomAnchor, constant: 10),
            favouritesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favouritesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favouritesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Action Methods
    
    
    @objc private func moreOptionsTapped() {
        print("More options tapped")
        // Implement more options functionality
    }
    
    @objc private func collectionsLabelTapped() {
        let collectionVC = CollectionViewController()
        navigationController?.pushViewController(collectionVC, animated: true)
    }
    
    @objc private func navigateToDetailPage() {
        let detailVC = CollectionViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    @objc private func addNoteTapped() {
        let uploadVC = UploadModalViewController()
        uploadVC.modalPresentationStyle = .pageSheet
        if let sheet = uploadVC.sheetPresentationController {
            sheet.detents = [.custom { context in
                return context.maximumDetentValue * 0.75
            }]
            sheet.prefersGrabberVisible = true
        }
        present(uploadVC, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCardCell.identifier, for: indexPath) as! NoteCardCell
        let noteCard = noteCards[indexPath.item]
        cell.configure(with: noteCard)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSubject = noteCards[indexPath.item]
        let pdfViewerVC = PDFViewerViewController(pdfURL: selectedSubject.pdfUrl)
        navigationController?.pushViewController(pdfViewerVC, animated: true)
    }
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello, this is a single row"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - UISearchBarDelegate

extension FavouriteViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text: \(searchText)")
    }
}

// MARK: - NoteCardCell

class NoteCardCell: UICollectionViewCell {
    static let identifier = "NoteCardCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 4)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        contentView.layer.masksToBounds = true
        layer.masksToBounds = false
        layer.cornerRadius = 12
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(favoriteIcon)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
                   // Larger cover image with full width
                   coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                   coverImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                   coverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9), // 90% of card width
                   coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor), // Make it square

                   // Title below image
                   titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 12),
                   titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                   titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

                   // Favorite icon and author
                   favoriteIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                   favoriteIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                   favoriteIcon.widthAnchor.constraint(equalToConstant: 20),
                   favoriteIcon.heightAnchor.constraint(equalToConstant: 20),

                   authorLabel.centerYAnchor.constraint(equalTo: favoriteIcon.centerYAnchor),
                   authorLabel.leadingAnchor.constraint(equalTo: favoriteIcon.trailingAnchor, constant: 8),
                   authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

                   // Description at the bottom
                   descriptionLabel.topAnchor.constraint(equalTo: favoriteIcon.bottomAnchor, constant: 8),
                   descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                   descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                   descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
               ])
           }

           func configure(with noteCard: NoteCard) {
               titleLabel.text = noteCard.title
               authorLabel.text = noteCard.author
               descriptionLabel.text = noteCard.description
               coverImageView.image = noteCard.coverImage
           }
       }
       extension FavouriteViewController {
           func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               let width = (collectionView.frame.width / 2) - 10
               return CGSize(width: width, height: 330) // Increased height to accommodate larger image
           }
       }





#Preview {
   FavouriteViewController()
}
