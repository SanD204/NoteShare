import UIKit

class CollectionSavedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    let notes: [CNote] = [
        CNote(title: "Double Integrals",
             description: "An introduction to double integrals,focusing on area calculations in higher dimensions.",
             author: "Awnish",
             coverImage: UIImage(named: "math1"),
             pdfUrl: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        CNote(title: "Functions",
             description: "A deep dive into mathematical functions and their properties.",
             author: "Hindberg",
             coverImage: UIImage(named: "math1"),
             pdfUrl: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        CNote(title: "Integrals",
             description: "A comprehensive study on integrals and their applications.",
             author: "Amit",
             coverImage: UIImage(named: "math1"),
             pdfUrl: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        CNote(title: "Algebra",
             description: "Understanding the basics and advanced topics in algebra.",
             author: "Allen Johnson",
             coverImage: UIImage(named: "math1"),
             pdfUrl: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        CNote(title: "Trigonometry",
             description: "Exploring the relationships between angles and sides of triangles.",
             author: "prof john",
             coverImage: UIImage(named: "math1"),
             pdfUrl: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        CNote(title: "Physics",
             description: "A comprehensive guide to concepts in classical and modern physics.",
             author: "Prof. John",
             coverImage: UIImage(named: "math1"),
             pdfUrl: Bundle.main.url(forResource: "test", withExtension: "pdf")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Set background color for the main view
        view.backgroundColor = .white
        
        // Setup navigation bar
        title = "Saved Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Configure collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        
        // Initialize collection view with zero frame
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        // Fix #1: Register the correct cell class with the correct identifier
        collectionView.register(SavedNoteCell.self, forCellWithReuseIdentifier: "savedNoteCells")
        
        // Add collection view to view hierarchy
        view.addSubview(collectionView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Fix #2: Use the same identifier as registered
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedNoteCells", for: indexPath) as! SavedNoteCell
        let note = notes[indexPath.item]
        cell.configure(note: note)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let selectedSubject = notes[indexPath.item]
         let pdfViewerVC = PDFViewerViewController(pdfURL: selectedSubject.pdfUrl)
         navigationController?.pushViewController(pdfViewerVC, animated: true)
     }
    
}

// Fix #3: Rename the class to match Swift naming conventions and make it consistent
class SavedNoteCell: UICollectionViewCell {
    private let cardView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let authorLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Setup card view
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cardView.layer.shadowRadius = 15
        cardView.layer.masksToBounds = false
        cardView.backgroundColor = .white
        contentView.addSubview(cardView)
        
        // Setup image view
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cardView.addSubview(imageView)
        
        // Setup title label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .darkGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        
        // Setup description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 3
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(descriptionLabel)
        
        // Setup author label
        authorLabel.font = UIFont.italicSystemFont(ofSize: 12)
        authorLabel.textColor = .gray
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(authorLabel)
        
        // Setup date label
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(dateLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Card view constraints
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Image view constraints
            imageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            // Description label constraints
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            // Author label constraints
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            authorLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            // Date label constraints
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12)
        ])
    }
    
    func configure(note: CNote) {
        titleLabel.text = note.title
        descriptionLabel.text = note.description
        authorLabel.text = "By \(note.author)"
        dateLabel.text = "Created on: \(formattedDate(date: note.dateCreated))"
        imageView.image = note.coverImage
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
