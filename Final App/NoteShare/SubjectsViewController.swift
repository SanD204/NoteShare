import UIKit
class SubjectCell: UICollectionViewCell {
    static let identifier = "SubjectCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(iconImageView)
        cardView.addSubview(labelStackView)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            iconImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),

            labelStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            labelStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with subject: Subject) {
        iconImageView.image = subject.image
        titleLabel.text = subject.title
        subtitleLabel.text = subject.subtitle
    }
}




class SubjectsViewController: UIViewController {
    private var selectedSubject: Subject?

    private lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.text = "Artificial Intelligence"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 32, height: 80)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SubjectCell.self, forCellWithReuseIdentifier: SubjectCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var subjectData: [Subject] = [
        Subject(title: "Artificial Intelligence", subtitle: "Machine Learning", image: UIImage(named: "Ai_logo") ?? UIImage(), pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        Subject(title: "Regression", subtitle: "Linear Regression, Logical Regression", image: UIImage(named: "automata_icon") ?? UIImage(), pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        Subject(title: "Computer Vision", subtitle: "Image Processing", image: UIImage(named: "ml_cover") ?? UIImage(), pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        Subject(title: "Deep Learning", subtitle: "Neural Networks", image: UIImage(named: "Ai_logo") ?? UIImage(), pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
       
        Subject(title: "LLMs", subtitle: "Netsuite, OpenAI", image: UIImage(named: "automata_icon") ?? UIImage(), pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!),
        Subject(title: "CNN", subtitle: "ReLU Layer, Pooling Layer", image: UIImage(named: "ml_cover") ?? UIImage(), pdfURL: Bundle.main.url(forResource: "test", withExtension: "pdf")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    

    private func setupUI() {
        view.addSubview(headingLabel)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])

        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension SubjectsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjectData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectCell.identifier, for: indexPath) as? SubjectCell else {
            return UICollectionViewCell()
        }

        let subject = subjectData[indexPath.item]
        cell.configure(with: subject)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSubject = subjectData[indexPath.item]
        let pdfViewerVC = PDFViewerViewController(pdfURL: selectedSubject?.pdfURL ?? Bundle.main.url(forResource: "test", withExtension: "pdf")!)
        navigationController?.pushViewController(pdfViewerVC, animated: true)
    }
}

#Preview(){
    SubjectsViewController()
}
