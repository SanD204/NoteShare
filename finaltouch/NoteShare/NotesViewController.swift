import UIKit

class NotesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
        let notes: [Note] = [
        Note(title: "Double Integrals",
             description: "An introduction to double integrals,focusing on area calculations in higher dimensions.",
             author: "Awnish",
             coverImage: UIImage(named: "maths_notes_icon")),
        Note(title: "Functions",
             description: "A deep dive into mathematical functions and their properties.",
             author: "Hindberg",
             coverImage: UIImage(named: "functions_notes_icon")),
        Note(title: "Integrals",
             description: "A comprehensive study on integrals and their applications.",
             author: "Amit",
             coverImage: UIImage(named: "integral_notes_icon")),
        Note(title: "Algebra",
             description: "Understanding the basics and advanced topics in algebra.",
             author: "Allen Johnson",
             coverImage: UIImage(named: "algebra_notes_icon")),
        Note(title: "Trigonometry",
             description: "Exploring the relationships between angles and sides of triangles.",
             author: "prof john",
             coverImage: UIImage(named: "trigo_notes_icon")),
        Note(title: "Physics",
             description: "A comprehensive guide to concepts in classical and modern physics.",
             author: "Prof. John",
             coverImage: UIImage(named: "pie_notes_icon"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Mathematics Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(NoteCells.self, forCellWithReuseIdentifier: "NoteCells")
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCells", for: indexPath) as! NoteCells
        let note = notes[indexPath.item]
        cell.configure(note: note)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 30) / 2, height: 350)
    }
}

import UIKit

class NoteCells: UICollectionViewCell {
    private let cardView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let authorLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cardView.layer.shadowRadius = 15
        cardView.layer.masksToBounds = false
        cardView.backgroundColor = .white
        contentView.addSubview(cardView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        cardView.addSubview(imageView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .darkGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 3
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(descriptionLabel)
        
        authorLabel.font = UIFont.italicSystemFont(ofSize: 12)
        authorLabel.textColor = .gray
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(authorLabel)
    
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            authorLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(note: Note) {
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

