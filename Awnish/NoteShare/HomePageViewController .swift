import UIKit
class NoteCollectionViewCell: UICollectionViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
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
        contentView.addSubview(containerView)
        
        [coverImageView, titleLabel, authorLabel, descriptionLabel].forEach {
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with note: Note) {
        titleLabel.text = note.title
        authorLabel.text = "By \(note.author)"
        descriptionLabel.text = note.description
        coverImageView.image = note.coverImage
    }
    
}

// MARK: - SharedNoteTableViewCell.swift
class SharedNoteTableViewCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let folderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        [folderImageView, titleLabel, dateLabel].forEach { containerView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            folderImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            folderImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            folderImageView.widthAnchor.constraint(equalToConstant: 24),
            folderImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: folderImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with note: Note) {
        titleLabel.text = "Shared by \(note.author)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = "Modified \(dateFormatter.string(from: note.lastModified))"
    }
}
class RecentFileCollectionViewCell: UICollectionViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fileSizeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
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
        contentView.addSubview(containerView)
        [iconImageView, nameLabel, fileSizeLabel].forEach { containerView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Position icon on the left
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Stack labels vertically next to the icon
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            fileSizeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            fileSizeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            fileSizeLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            fileSizeLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with file: RecentFile) {
        iconImageView.image = file.icon
        nameLabel.text = file.name
        fileSizeLabel.text = file.fileSize
    }
}

class HomeViewController: UIViewController {
    // MARK: - Properties
    private let notes: [Note] = [
        Note(title: "Understanding Machine Learning",
             description: "An overview of the fundamental concepts of machine learning.",
             author: "Jane Smith",
             coverImage: UIImage(named: "ml_cover")),
        Note(title: "iOS Development 101",
             description: "This note explores the basics of iOS development.",
             author: "Alice Johnson",
             coverImage: UIImage(named: "ios_dev_cover")),
        Note(title: "Advanced Algorithms",
             description: "A deep dive into advanced algorithms.",
             author: "Bob Brown",
             coverImage: UIImage(named: "algorithms_cover"))
    ]
    
    private let sharedNotes: [Note] = [
        Note(title: "Shared Note 1",
             description: "Description 1",
             author: "David Wilson",
             coverImage: nil),
        Note(title: "Shared Note 2",
             description: "Description 2",
             author: "Emma Davis",
             coverImage: nil)
    ]
    
    private let recentFiles: [RecentFile] = [
        RecentFile(name: "Project Notes",
                  icon: UIImage(systemName: "doc.text.fill"),
                  fileSize: "2.1 MB"),
        RecentFile(name: "Meeting Minutes",
                  icon: UIImage(systemName: "doc.fill"),
                  fileSize: "856 KB"),
        RecentFile(name: "Research Paper",
                  icon: UIImage(systemName: "doc.richtext.fill"),
                  fileSize: "1.8 MB")
    ]
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var notesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 280)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: "NoteCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let notesLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Notes"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sharedNotesLabel: UILabel = {
        let label = UILabel()
        label.text = "Shared with You"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sharedNotesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(SharedNoteTableViewCell.self, forCellReuseIdentifier: "SharedNoteCell")
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let recentFilesLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Files"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var recentFilesCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            // Update the size to be more horizontal
            layout.itemSize = CGSize(width: 200, height: 60)
            layout.minimumInteritemSpacing = 12
            layout.minimumLineSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(RecentFileCollectionViewCell.self, forCellWithReuseIdentifier: "RecentFileCell")
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
    }
    
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerLabel, notesLabel, notesCollectionView, sharedNotesLabel, sharedNotesTableView,
         recentFilesLabel, recentFilesCollectionView].forEach { contentView.addSubview($0) }
        
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
            
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            notesLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            notesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            notesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            notesCollectionView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 16),
            notesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            notesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            notesCollectionView.heightAnchor.constraint(equalToConstant: 280),
            
            sharedNotesLabel.topAnchor.constraint(equalTo: notesCollectionView.bottomAnchor, constant: 24),
            sharedNotesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sharedNotesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            sharedNotesTableView.topAnchor.constraint(equalTo: sharedNotesLabel.bottomAnchor, constant: 16),
            sharedNotesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sharedNotesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sharedNotesTableView.heightAnchor.constraint(equalToConstant: CGFloat(sharedNotes.count * 80)),
            
            recentFilesLabel.topAnchor.constraint(equalTo: sharedNotesTableView.bottomAnchor, constant: 24),
            recentFilesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recentFilesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            recentFilesCollectionView.topAnchor.constraint(equalTo: recentFilesLabel.bottomAnchor, constant: 16),
            recentFilesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recentFilesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recentFilesCollectionView.heightAnchor.constraint(equalToConstant: 60),
            recentFilesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupDelegates() {
        notesCollectionView.dataSource = self
        notesCollectionView.delegate = self
        
        sharedNotesTableView.dataSource = self
        sharedNotesTableView.delegate = self
        
        recentFilesCollectionView.dataSource = self
        recentFilesCollectionView.delegate = self
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.section == 1 {
//            let cardVC = CardViewController()
//            navigationController?.pushViewController(cardVC, animated: true)
//        }
//    }


   
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == notesCollectionView {
            return notes.count
        } else if collectionView == recentFilesCollectionView {
            return recentFiles.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == notesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCollectionViewCell
            cell.configure(with: notes[indexPath.item])
            return cell
        } else if collectionView == recentFilesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentFileCell", for: indexPath) as! RecentFileCollectionViewCell
            cell.configure(with: recentFiles[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharedNoteCell", for: indexPath) as! SharedNoteTableViewCell
        cell.configure(with: sharedNotes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


