import UIKit
import PDFKit

class TopCollegesView: UIView {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let topCollegeLabel: UILabel = {
        let label = UILabel()
        label.text = "Top Colleges"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TopCollegeCell.self, forCellWithReuseIdentifier: TopCollegeCell.identifier)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(topCollegeLabel)
        scrollView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            topCollegeLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            topCollegeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            topCollegeLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topCollegeLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}


class TopCollegeCell: UICollectionViewCell {
    static let identifier = "TopCollegeCell"

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
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
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 48),
            logoImageView.heightAnchor.constraint(equalToConstant: 48),

            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with college: College) {
        logoImageView.image = college.image
        nameLabel.text = college.title
    }
}


class SectionHeaderView: UICollectionReusableView {
    static let identifier = "SectionHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with title: String) {
        titleLabel.text = title
    }
}

class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
    private let exploreLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let topColleges: [College] = [
        College(title: "SRMIST", subtitle: "Top University", image: UIImage(named: "srmist_logo") ?? UIImage(systemName: "photo")!),
        College(title: "IIT Kanpur", subtitle: "Premier Institute", image: UIImage(named: "iit_kanpur_logo") ?? UIImage(systemName: "photo")!),
        College(title: "NIT Trichy", subtitle: "National Institute", image: UIImage(named: "nit_trichy_logo") ?? UIImage(systemName: "photo")!),
        College(title: "BITS Pilani", subtitle: "Private Institution", image: UIImage(named: "bits_pilani_logo") ?? UIImage(systemName: "photo")!),
        College(title: "IIT Madras", subtitle: "IIT Hub", image: UIImage(named: "iit_madras_logo") ?? UIImage(systemName: "photo")!),
        College(title: "IIT Bombay", subtitle: "IIT Hub", image: UIImage(named: "iit_bombay_logo") ?? UIImage(systemName: "photo")!)

    ]
    
    private let subjects: [Subject] = [
        Subject(title: "Computer Networking", subtitle: "Networking Basics", image: UIImage(named: "networking_icon") ?? UIImage(systemName: "photo")!, pdfURL: URL(string: "https://example.com/computer-networking.pdf")!),
        Subject(title: "Chemistry", subtitle: "Study of Matter", image: UIImage(named: "chemistry_icon") ?? UIImage(systemName: "photo")!, pdfURL: URL(string: "https://example.com/chemistry.pdf")!),
        Subject(title: "Formal Language & Automata", subtitle: "Theory of Computation", image: UIImage(named: "automata_icon") ?? UIImage(systemName: "photo")!, pdfURL: URL(string: "https://example.com/formal-language-automata.pdf")!)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
        setupExploreLabel()
        setupCollectionView()
    }

    private func setupExploreLabel() {
        view.addSubview(exploreLabel)
        NSLayoutConstraint.activate([
            exploreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            exploreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(TopCollegeCell.self, forCellWithReuseIdentifier: TopCollegeCell.identifier)
        collectionView.register(SubjectCell.self, forCellWithReuseIdentifier: SubjectCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: exploreLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? topColleges.count : subjects.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollegeCell.identifier, for: indexPath) as! TopCollegeCell
            cell.configure(with: topColleges[indexPath.item])
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectCell.identifier, for: indexPath) as! SubjectCell
            cell.configure(with: subjects[indexPath.item])
            return cell
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 120, height: 100) // Smaller cell for Top College with horizontal scrolling
        }
        else {
            return CGSize(width: collectionView.bounds.width - 20, height: 120)
        }
    }

    // Section header configuration
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
        headerView.configure(with: indexPath.section == 0 ? "Top Colleges" : "Subjects")
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }

    // Configure horizontal scroll for "Top Colleges" section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, scrollDirectionForSectionAt section: Int) -> UICollectionView.ScrollDirection {
        return section == 0 ? .horizontal : .vertical
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            _ = subjects[indexPath.item]
            let subjectVC = SubjectsViewController()
            navigationController?.pushViewController(subjectVC, animated: true)
        }
    }
}

#Preview(){
    ExploreViewController()
}
