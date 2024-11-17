import UIKit
import PDFKit

class SharedNotesViewController: UIViewController {
    var username: String = ""
    private var collectionView: UICollectionView!
    private let headingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let items: [CardItem] = [
        CardItem(image: "algorithms_cover", title: "DS Algorithms", description: "Djisktra algorithm, Knapsack problem", pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        CardItem(image: "ios_dev_cover", title: "iOS Development", description: "Develop in Swift Fundamentals", pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        CardItem(image: "chemistry_icon", title: "Chemistry", description: "Organic Chemistry topics", pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        CardItem(image: "maths_pic", title: "Discrete Maths", description: "Permutation Group, Cyclic Group", pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        CardItem(image: "ml_cover", title: "Machine Learning", description: "Linear Regression, Logistic Regression", pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        CardItem(image: "networking_icon", title: "Computer Networks", description: "Networking Protocols", pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!)
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        headingLabel.text = "Shared by \(username)"
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(headingLabel)
        setupCollectionView()
        setupConstraints()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray6
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionView Extensions
extension SharedNotesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as! CardCollectionViewCell
        let item = items[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let collectionViewWidth = collectionView.bounds.width
        let availableWidth = collectionViewWidth - padding * 3
        let width = availableWidth / 2
        let height: CGFloat = 250
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.item]
        let pdfViewerVC = PDFViewerViewController(pdfURL: selectedItem.pdfURL)
        pdfViewerVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(pdfViewerVC, animated: true)
    }
}

class CardCollectionViewCell: UICollectionViewCell {
    static let identifier = "CardCollectionViewCell"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with item: CardItem) {
        imageView.image = UIImage(named: item.image)
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
}

// MARK: - Model
struct CardItem {
    let image: String
    let title: String
    let description: String
    let pdfURL: URL
}

//#Preview() {
//    SharedNotesViewController()
//}


