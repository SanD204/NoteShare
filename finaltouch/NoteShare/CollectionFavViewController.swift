import UIKit

class CollectionFavViewController: UIViewController {
    
    private let favouritesLabel: UILabel = {
        let label = UILabel()
        label.text = "Favourites"
        label.font = .systemFont(ofSize: 28, weight: .semibold)
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
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        
        // Add favourites section
        view.addSubview(favouritesLabel)
        NSLayoutConstraint.activate([
            favouritesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            favouritesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        
        favouritesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        favouritesCollectionView?.delegate = self
        favouritesCollectionView?.dataSource = self
        favouritesCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        favouritesCollectionView?.register(favNoteCardCell.self, forCellWithReuseIdentifier: favNoteCardCell.identifier)
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
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension CollectionFavViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favNoteCardCell.identifier, for: indexPath) as! favNoteCardCell
        let noteCard = noteCards[indexPath.item]
        cell.configure(with: noteCard)
        return cell
    }
}

// MARK: - NoteCardCell

class favNoteCardCell: UICollectionViewCell {
    static let identifier = "favNoteCardCell"
    
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
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            favoriteIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            favoriteIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 20),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 20),
            
            authorLabel.centerYAnchor.constraint(equalTo: favoriteIcon.centerYAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: favoriteIcon.trailingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
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


extension CollectionFavViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 10
        return CGSize(width: width, height: 330)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSubject = noteCards[indexPath.item]
        let pdfViewerVC = PDFViewerViewController(pdfURL: selectedSubject.pdfUrl)
        navigationController?.pushViewController(pdfViewerVC, animated: true)
    }
}
#Preview {
    CollectionFavViewController()
}


