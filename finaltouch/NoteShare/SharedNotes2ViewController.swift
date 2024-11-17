//
//  SharedNotes2ViewController.swift
//  NoteShare
//
//  Created by admin69 on 17/11/24.
//

import UIKit

// MARK: - Topic Model
struct Topic {
    let title: String
    let subtitle: String
    let image: UIImage? // Made optional
    
    // Added initializer with default image
    init(title: String, subtitle: String, imageName: String) {
        self.title = title
        self.subtitle = subtitle
        self.image = UIImage(named: imageName) ?? UIImage(systemName: "questionmark.square") // Fallback image
    }
}

// MARK: - TopicCell
class TopicCell: UICollectionViewCell {
    static let identifier = "TopicCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.clipsToBounds = true  // Added to ensure image doesn't overflow rounded corners
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit  // Changed from .scaleAspectFit to take full area
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "questionmark.square")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor), // Make it square
            
            // Updated image constraints to fill the container
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with topic: Topic) {
        titleLabel.text = topic.title
        subtitleLabel.text = topic.subtitle
        if let topicImage = topic.image {
            iconImageView.image = topicImage
        }
    }
}

// MARK: - TopicsViewController
class TopicsViewController: UIViewController {
    private let topics: [Topic] = [
        Topic(title: "DS Algorithms",
              subtitle: "Dijkstra algorithm, Knapsack problem",
              imageName: "algorithms_cover"),
        Topic(title: "iOS Development",
              subtitle: "Develop in Swift Fundamentals",
              imageName: "ios_dev_cover"),
        Topic(title: "Chemistry",
              subtitle: "Organic Chemistry topics",
              imageName: "chemistry_icon"),
        Topic(title: "Discrete Maths",
              subtitle: "Permutation Group, Cyclic Group",
              imageName: "maths_pic"),
        Topic(title: "Machine Learning",
              subtitle: "Linear Regression, Logistic Regression",
              imageName: "ml_cover"),
        Topic(title: "Computer Networks",
              subtitle: "Networking Protocols",
              imageName: "networking_icon")
    ]
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Shared by Awnish"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension TopicsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: topics[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 48) / 2
        return CGSize(width: width, height: width * 1.3)
    }
}
#Preview() {
    TopicsViewController()
}
