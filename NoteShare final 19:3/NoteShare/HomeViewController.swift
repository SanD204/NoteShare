import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import PDFKit

struct FireNote {
    let id: String
    let title: String
    let description: String
    let author: String
    let coverImage: UIImage?
    let pdfUrl: String
    let dateAdded: Date
    let pageCount: Int
    let fileSize: String
    var isFavorite: Bool
    let category:String
    let subjectCode: String
    let subjectName: String
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "title": title,
            "description": description,
            "author": author,
            "pdfUrl": pdfUrl,
            "dateAdded": dateAdded,
            "pageCount": pageCount,
            "fileSize": fileSize,
            "isFavorite": isFavorite,
            "category":category,
            "subjectCode":subjectCode,
            "subjectName":subjectName
        ]
    }
}

extension FirebaseService {
    func fetchNotes() async throws -> ([FireNote], [String: [String: [FireNote]]]) {
        return try await withCheckedThrowingContinuation { continuation in
            db.collection("pdfs")
                .whereField("privacy", isEqualTo: "public")
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }

                    var notes: [FireNote] = []
                    var groupedNotes: [String: [String: [FireNote]]] = [:]
                    let group = DispatchGroup()

                    snapshot?.documents.forEach { document in
                        group.enter()
                        let data = document.data()
                        let pdfUrl = data["downloadURL"] as? String ?? ""
                        let collegeName = data["collegeName"] as? String ?? "Unknown College"
                        let subjectCode = data["subjectCode"] as? String ?? "Unknown Subject"

                        self.getStorageReference(from: pdfUrl)?.getMetadata { metadata, error in
                            if let error = error { print("Metadata error for \(pdfUrl): \(error)") }
                            let fileSize = self.formatFileSize(metadata?.size ?? 0)

                            self.fetchPDFCoverImage(from: pdfUrl) { (image, pageCount) in
                                let note = FireNote(
                                    id: document.documentID,
                                    title: data["fileName"] as? String ?? "Untitled",
                                    description: data["category"] as? String ?? "",
                                    author: collegeName,
                                    coverImage: image,
                                    pdfUrl: pdfUrl,
                                    dateAdded: (metadata?.timeCreated ?? Date()),
                                    pageCount: pageCount,
                                    fileSize: fileSize,
                                    isFavorite: false,
                                    category: data["category"] as? String ?? "",
                                    subjectCode: subjectCode,
                                    subjectName: data["subjectName"] as? String ?? ""
                                )
                                notes.append(note)
                                if groupedNotes[collegeName] == nil { groupedNotes[collegeName] = [:] }
                                if groupedNotes[collegeName]?[subjectCode] != nil {
                                    groupedNotes[collegeName]?[subjectCode]?.append(note)
                                } else {
                                    groupedNotes[collegeName]?[subjectCode] = [note]
                                }
                                group.leave()
                            }
                        }
                    }

                    group.notify(queue: .main) {
                        self.fetchUserFavorites { favoriteNoteIds in
                            let updatedNotes = notes.map { note in
                                var updatedNote = note
                                updatedNote.isFavorite = favoriteNoteIds.contains(note.id)
                                return updatedNote
                            }
                            continuation.resume(returning: (updatedNotes.sorted { $0.dateAdded > $1.dateAdded }, groupedNotes))
                        }
                    }
                }
        }
    }

    // Similarly refactor fetchUserFavorites to async/await
    private func fetchUserFavorites() async throws -> [String] {
        guard let userId = currentUserId else { return [] }
        return try await withCheckedThrowingContinuation { continuation in
            db.collection("userFavorites").document(userId).collection("favorites")
                .whereField("isFavorite", isEqualTo: true)
                .getDocuments { snapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    let favoriteIds = snapshot?.documents.map { $0.documentID } ?? []
                    continuation.resume(returning: favoriteIds)
                }
        }
    }
}

// previously read note struct
struct PreviouslyReadNote {
    let id: String
    let title: String
    let pdfUrl: String
    let lastOpened: Date
}

class FirebaseService {
    static let shared = FirebaseService()
    private let storage = Storage.storage()
    private let db = Firestore.firestore()

    var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    // Fetch all notes (unchanged, but removing isFavorite from note fetch)
    func fetchNotes(completion: @escaping ([FireNote], [String: [String: [FireNote]]]) -> Void) {
        db.collection("pdfs")
            .whereField("privacy", isEqualTo: "public") // Filter for public PDFs only
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching notes: \(error.localizedDescription)")
                    completion([], [:])
                    return
                }

                var notes: [FireNote] = []
                var groupedNotes: [String: [String: [FireNote]]] = [:]
                let group = DispatchGroup()

                snapshot?.documents.forEach { document in
                    group.enter()
                    let data = document.data()
                    let pdfUrl = data["downloadURL"] as? String ?? ""
                    print("Fetching note with pdfUrl: \(pdfUrl)")
                    let collegeName = data["collegeName"] as? String ?? "Unknown College"
                    let subjectCode = data["subjectCode"] as? String ?? "Unknown Subject"

                    self.getStorageReference(from: pdfUrl)?.getMetadata { metadata, error in
                        if let error = error { print("Metadata error for \(pdfUrl): \(error)") }
                        let fileSize = self.formatFileSize(metadata?.size ?? 0)

                        self.fetchPDFCoverImage(from: pdfUrl) { (image, pageCount) in
                            let note = FireNote(
                                id: document.documentID,
                                title: data["fileName"] as? String ?? "Untitled",
                                description: data["category"] as? String ?? "",
                                author: collegeName,
                                coverImage: image,
                                pdfUrl: pdfUrl,
                                dateAdded: (metadata?.timeCreated ?? Date()),
                                pageCount: pageCount,
                                fileSize: fileSize,
                                isFavorite: false,
                                category: data["category"] as? String ?? "",
                                subjectCode: subjectCode,
                                subjectName: data["subjectName"] as? String ?? ""
                            )
                            notes.append(note)
                            if groupedNotes[collegeName] == nil { groupedNotes[collegeName] = [:] }
                            if groupedNotes[collegeName]?[subjectCode] != nil {
                                groupedNotes[collegeName]?[subjectCode]?.append(note)
                            } else {
                                groupedNotes[collegeName]?[subjectCode] = [note]
                            }
                            group.leave()
                        }
                    }
                }

                group.notify(queue: .main) {
                    self.fetchUserFavorites { favoriteNoteIds in
                        let updatedNotes = notes.map { note in
                            var updatedNote = note
                            updatedNote.isFavorite = favoriteNoteIds.contains(note.id)
                            return updatedNote
                        }
                        print("Fetched \(updatedNotes.count) notes")
                        completion(updatedNotes.sorted { $0.dateAdded > $1.dateAdded }, groupedNotes)
                    }
                }
            }
    }
    
    // Fetch the current user's favorite note IDs
        private func fetchUserFavorites(completion: @escaping ([String]) -> Void) {
            guard let userId = currentUserId else {
                completion([])
                return
            }

            db.collection("userFavorites").document(userId).collection("favorites")
                .whereField("isFavorite", isEqualTo: true)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching favorites: \(error)")
                        completion([])
                        return
                    }
                    let favoriteIds = snapshot?.documents.map { $0.documentID } ?? []
                    completion(favoriteIds)
                }
        }
    
    // Ensure fetchUserData matches the expected signature
        func fetchUserData(completion: @escaping ([String], String) -> Void) {
            guard let userId = currentUserId else {
                completion([], "")
                return
            }
            
            let userRef = db.collection("users").document(userId)
            userRef.getDocument { document, error in
                if let error = error {
                    print("Error fetching user data: \(error)")
                    completion([], "")
                    return
                }
                
                guard let document = document, document.exists else {
                    completion([], "")
                    return
                }
                
                let data = document.data() ?? [:]
                let interests = data["interests"] as? [String] ?? []
                let college = data["college"] as? String ?? ""
                
                completion(interests, college)
            }
        }
    
    // Fetch recommended notes with favorite status
        func fetchRecommendedNotes(completion: @escaping ([FireNote]) -> Void) {
            fetchUserData { [weak self] interests, college in
                guard let self = self else { return }
                
                self.fetchNotes { allNotes, _ in
                    var recommendedNotes = [FireNote]()
                    let lowercasedCollege = college.lowercased()
                    
                    var interestMatches = allNotes.filter { note in
                        interests.contains { interest in
                            note.category.lowercased().contains(interest.lowercased())
                        }
                    }
                    
                    var collegeMatches = allNotes.filter { note in
                        !interestMatches.contains(where: { $0.id == note.id }) &&
                        note.author.lowercased() == lowercasedCollege
                    }
                    
                    interestMatches.sort { $0.dateAdded > $1.dateAdded }
                    collegeMatches.sort { $0.dateAdded > $1.dateAdded }
                    
                    recommendedNotes = interestMatches
                    if recommendedNotes.isEmpty {
                        recommendedNotes = Array(allNotes.prefix(5))
                    } else {
                        recommendedNotes = Array(recommendedNotes.prefix(5))
                    }
                    
                    completion(recommendedNotes)
                }
            }
        }
    
    
    // Download PDF from Firebase Storage
    func downloadPDF(from urlString: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard !urlString.isEmpty else {
            let error = NSError(domain: "PDFDownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty PDF URL"])
            print("Download failed: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        guard let storageRef = getStorageReference(from: urlString) else {
            let error = NSError(domain: "PDFDownloadError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid storage reference URL: \(urlString)"])
            print("Download failed: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        let fileName = UUID().uuidString + ".pdf"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let localURL = documentsPath.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: localURL.path) {
            do {
                try FileManager.default.removeItem(at: localURL)
                print("Removed existing file at \(localURL.path)")
            } catch {
                print("Failed to remove existing file: \(error)")
                completion(.failure(error))
                return
            }
        }

        print("Starting download from \(urlString) to \(localURL.path)")
        let downloadTask = storageRef.write(toFile: localURL) { url, error in
            if let error = error {
                // Enhanced error logging
                if let nsError = error as NSError? {
                    let errorCode = nsError.code
                    let errorDesc = nsError.localizedDescription
                    let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError
                    print("Download error for \(urlString): Code \(errorCode) - \(errorDesc)")
                    if let underlyingDesc = underlyingError?.localizedDescription {
                        print("Underlying error: \(underlyingDesc)")
                    }
                } else {
                    print("Download error for \(urlString): \(error.localizedDescription)")
                }
                completion(.failure(error))
                return
            }

            guard let url = url else {
                let error = NSError(domain: "PDFDownloadError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Downloaded file URL is nil"])
                print("Download failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if FileManager.default.fileExists(atPath: url.path) {
                if let pdfDocument = PDFDocument(url: url) {
                    print("PDF loaded successfully with \(pdfDocument.pageCount) pages at \(url.path)")
                    completion(.success(url))
                } else {
                    let error = NSError(domain: "PDFDownloadError", code: -4, userInfo: [NSLocalizedDescriptionKey: "Invalid PDF at \(url.path)"])
                    print("Download failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "PDFDownloadError", code: -5, userInfo: [NSLocalizedDescriptionKey: "File not found at \(url.path) after download"])
                print("Download failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }

        downloadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress?.completedUnitCount ?? 0) /
                Double(snapshot.progress?.totalUnitCount ?? 1)
            print("Download progress for \(urlString): \(percentComplete)%")
        }
    }
    
    
    
    private func formatFileSize(_ size: Int64) -> String {
        if size <= 0 {
            return "Unknown Size"
        }
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
    
    private func getStorageReference(from urlString: String) -> StorageReference? {
        if urlString.starts(with: "gs://") {
            return storage.reference(forURL: urlString)
        }
        
        if urlString.contains("firebasestorage.googleapis.com") {
            return storage.reference(forURL: urlString)
        }
        
        return storage.reference().child(urlString)
    }
    
//    fav
    // Update favorite status for a note
    func updateFavoriteStatus(for noteId: String, isFavorite: Bool, completion: @escaping (Error?) -> Void) {
            guard let userId = currentUserId else {
                completion(NSError(domain: "FirebaseService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
                return
            }

            let favoriteRef = db.collection("userFavorites").document(userId).collection("favorites").document(noteId)

            if isFavorite {
                favoriteRef.setData([
                    "isFavorite": true,
                    "timestamp": Timestamp(date: Date())
                ]) { error in
                    if error == nil {
                        NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
                    }
                    completion(error)
                }
            } else {
                favoriteRef.delete { error in
                    if error == nil {
                        NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
                    }
                    completion(error)
                }
            }
        }
//    fav end
    
    private func fetchPDFCoverImage(from urlString: String, completion: @escaping (UIImage?, Int) -> Void) {
        guard !urlString.isEmpty else {
            print("Empty PDF URL provided")
            completion(nil, 0)
            return
        }

        guard let storageRef = getStorageReference(from: urlString) else {
            print("Invalid storage reference for URL: \(urlString)")
            completion(nil, 0)
            return
        }

        let tempDir = FileManager.default.temporaryDirectory
        let localURL = tempDir.appendingPathComponent(UUID().uuidString + ".pdf")

        storageRef.write(toFile: localURL) { url, error in
            if let error = error {
                print("Error downloading PDF for cover from \(urlString): \(error.localizedDescription)")
                completion(nil, 0)
                return
            }

            guard let pdfURL = url, FileManager.default.fileExists(atPath: pdfURL.path) else {
                print("Failed to download PDF to \(localURL.path)")
                completion(nil, 0)
                return
            }

            guard let pdfDocument = PDFDocument(url: pdfURL) else {
                print("Failed to create PDFDocument from \(pdfURL.path)")
                completion(nil, 0)
                return
            }

            let pageCount = pdfDocument.pageCount
            guard pageCount > 0, let pdfPage = pdfDocument.page(at: 0) else {
                print("No pages found in PDF at \(pdfURL.path)")
                completion(nil, pageCount)
                return
            }

            let pageRect = pdfPage.bounds(for: .mediaBox)
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            let image = renderer.image { context in
                UIColor.white.set()
                context.fill(pageRect)
                context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                context.cgContext.scaleBy(x: 1.0, y: -1.0)
                pdfPage.draw(with: .mediaBox, to: context.cgContext)
            }

            do {
                try FileManager.default.removeItem(at: pdfURL)
            } catch {
                print("Failed to delete temp file: \(error)")
            }

            completion(image, pageCount)
        }
    }
}

class NoteCollectionViewCell: UICollectionViewCell {
    var noteId: String?
    
    public let lastOpenedDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.05
        view.clipsToBounds = false // Allow shadow to show, but we'll clip subviews separately
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

 
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2 // Allow up to 2 lines for long titles
        label.lineBreakMode = .byTruncatingTail // Truncate if still too long
        label.adjustsFontSizeToFitWidth = true // Dynamically adjust font size
        label.minimumScaleFactor = 0.75 // Minimum font scale to prevent it from getting too small
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let subjectNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subjectCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let pagesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
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
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let recommendedTag: UILabel = {
        let label = UILabel()
        label.text = "Recommended"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Properties
    var isFavorite: Bool = false {
        didSet {
            updateFavoriteButtonImage()
        }
    }
    
    var favoriteButtonTapped: (() -> Void)?
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI Setup
    private func setupUI() {
        contentView.addSubview(containerView)
        
        [coverImageView, titleLabel, authorLabel, subjectNameLabel, subjectCodeLabel,
         detailsStackView, favoriteButton, recommendedTag, lastOpenedDateLabel].forEach {
            containerView.addSubview($0)
        }
        
        [pagesLabel, fileSizeLabel].forEach {
            detailsStackView.addArrangedSubview($0)
        }
        
        setupConstraints()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
    }
    
    private func setupConstraints() {
            NSLayoutConstraint.activate([
                // Container view constraints
                containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                
                // Cover image view
                coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
                coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                coverImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
                coverImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.65),
                
                // Title label
                titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
                
                // Author label
                authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                authorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                authorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
                
                // Details stack view
                detailsStackView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
                detailsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                detailsStackView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8), // Adjusted to respect favorite button
                
                // Favorite button (ensure it stays within container bounds)
                favoriteButton.centerYAnchor.constraint(equalTo: detailsStackView.centerYAnchor),
                favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
                favoriteButton.widthAnchor.constraint(equalToConstant: 24),
                favoriteButton.heightAnchor.constraint(equalToConstant: 24),
                favoriteButton.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8), // Ensure it doesn't overflow
                
                // Recommended tag
                recommendedTag.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
                recommendedTag.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                recommendedTag.heightAnchor.constraint(equalToConstant: 20),
                recommendedTag.widthAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        // Update UI for favorite button
        private func updateFavoriteButtonImage() {
            let image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            favoriteButton.setImage(image, for: .normal)
            favoriteButton.tintColor = isFavorite ? .systemBlue : .systemGray
        }
        
        // Favorite button pressed
        @objc private func favoriteButtonPressed() {
            isFavorite.toggle()
            updateFavoriteButtonImage()
            
            guard let noteId = noteId else { return }
            
            FirebaseService.shared.updateFavoriteStatus(for: noteId, isFavorite: isFavorite) { error in
                if let error = error {
                    print("Error updating favorite status: \(error.localizedDescription)")
                    self.isFavorite.toggle()
                    self.updateFavoriteButtonImage()
                }
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            titleLabel.text = nil
            subjectNameLabel.text = nil
            lastOpenedDateLabel.text = nil
            authorLabel.text = nil
            pagesLabel.text = nil
            fileSizeLabel.text = nil
            coverImageView.image = nil
            noteId = nil
            
            titleLabel.isHidden = true
            subjectNameLabel.isHidden = true
            lastOpenedDateLabel.isHidden = true
            authorLabel.isHidden = true
            subjectCodeLabel.isHidden = true
            fileSizeLabel.isHidden = true
            pagesLabel.isHidden = true
            favoriteButton.isHidden = true
            recommendedTag.isHidden = true
            detailsStackView.isHidden = true
            coverImageView.isHidden = true
            
            titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
            isFavorite = false
            updateFavoriteButtonImage()
            
            NSLayoutConstraint.deactivate(containerView.constraints)
            setupConstraints()
        }
        
        func configure(with note: FireNote) {
            print("Configuring note \(note.id) with favorite status: \(note.isFavorite)")
            noteId = note.id
            titleLabel.text = note.title
            authorLabel.text = note.author
            pagesLabel.text = "Pages: \(note.pageCount)"
            fileSizeLabel.text = note.fileSize
            coverImageView.image = note.coverImage ?? UIImage(systemName: "doc.fill")
            isFavorite = note.isFavorite
            
            titleLabel.isHidden = false
            authorLabel.isHidden = false
            pagesLabel.isHidden = false
            fileSizeLabel.isHidden = false
            coverImageView.isHidden = false
            detailsStackView.isHidden = false
            favoriteButton.isHidden = false
            subjectNameLabel.isHidden = true
            subjectCodeLabel.isHidden = true
            lastOpenedDateLabel.isHidden = true
            recommendedTag.isHidden = true
            
            titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
            
            NSLayoutConstraint.deactivate(containerView.constraints)
            setupConstraints()
            
            // Force layout update to ensure everything fits
            layoutIfNeeded()
        }
        
        // Previously read note UI (unchanged for this fix)
        func configureForPreviouslyRead(with note: PreviouslyReadNote, fullNote: FireNote?) {
            noteId = note.id
            titleLabel.text = note.title
            titleLabel.numberOfLines = 2
            titleLabel.lineBreakMode = .byTruncatingTail
            adjustTitleFontSize()
            titleLabel.isHidden = false
            
            subjectNameLabel.text = "Last opened"
            subjectNameLabel.isHidden = false
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            lastOpenedDateLabel.text = dateFormatter.string(from: note.lastOpened)
            lastOpenedDateLabel.isHidden = false
            
            coverImageView.isHidden = true
            authorLabel.isHidden = true
            subjectCodeLabel.isHidden = true
            fileSizeLabel.isHidden = true
            pagesLabel.isHidden = true
            favoriteButton.isHidden = true
            recommendedTag.isHidden = true
            detailsStackView.isHidden = true
            
            NSLayoutConstraint.deactivate(containerView.constraints)
            setupConstraints()
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
                
                subjectNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                subjectNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                subjectNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
                
                lastOpenedDateLabel.topAnchor.constraint(equalTo: subjectNameLabel.bottomAnchor, constant: 4),
                lastOpenedDateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                lastOpenedDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
                lastOpenedDateLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
            ])
            
            if let fullNote = fullNote {
                isFavorite = fullNote.isFavorite
            }
            
            containerView.layoutIfNeeded()
        }
        
        private func adjustTitleFontSize() {
            guard let text = titleLabel.text else { return }
            let maxWidth = containerView.bounds.width - 16 // Padding on both sides
            
            let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            
            let textRect = attributedText.boundingRect(
                with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil
            )
            
            if textRect.height > 40 { // Roughly two lines
                titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
            } else {
                titleLabel.font = font
            }
        }
}


struct College {
    let name: String
    let logo: UIImage?
}

class CollegeCell: UICollectionViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.color = .gray
            indicator.hidesWhenStopped = true
            indicator.translatesAutoresizingMaskIntoConstraints = false
            return indicator
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
        containerView.addSubview(logoImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(activityIndicator) // Add the activity indicator
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8),
            
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                        activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func configure(with college: College) {
        logoImageView.image = college.logo
        nameLabel.text = college.name
    }
}

class HomeViewController: UIViewController {
    // MARK: - Properties
    private var notes: [FireNote] = []
    private var isShowingCollegeNotes = false
    private var isLoading = false
    private let collegeReuseIdentifier = "CollegeCell"
    private let noteReuseIdentifier = "NoteCell"
    private var recommendedNotes: [FireNote] = []
    
    private let colleges: [College] = [
        College(name: "SRM", logo: UIImage(named: "srmist_logo")),
        College(name: "VIT", logo: UIImage(named: "vit_logo")),
        College(name: "KIIT", logo: UIImage(named: "kiit_new")),
        College(name: "Manipal", logo: UIImage(named: "manipal_new")),
        College(name: "LPU", logo: UIImage(named: "lpu_new")),
        College(name: "Amity", logo: UIImage(named: "amity_new"))
    ]
    
    // MARK: - UI Components
//    previously read note ui
    private var previouslyReadNotes: [PreviouslyReadNote] = []

    private let previouslyReadLabel: UILabel = {
        let label = UILabel()
        label.text = "Previously Read"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var previouslyReadCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 250, height: 110) // Increased height to 150
            layout.minimumInteritemSpacing = 20
            layout.minimumLineSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: noteReuseIdentifier)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
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
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 28)
        let image = UIImage(systemName: "person.crop.circle", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let notesLabel: UILabel = {
        let label = UILabel()
        label.text = "Recommended Notes"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var notesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 280)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: noteReuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let collegesLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore College Notes"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Add a placeholder view for when there are no previously read notes
        private let previouslyReadPlaceholderView: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGray6
            view.layer.cornerRadius = 12
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        private let placeholderLabel: UILabel = {
            let label = UILabel()
            label.text = "Start exploring notes!\nYour recently read notes will appear here."
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private lazy var collegesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let availableWidth = UIScreen.main.bounds.width - 64
        let itemWidth = availableWidth / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(CollegeCell.self, forCellWithReuseIdentifier: collegeReuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupDelegates()
            fetchNotes()
            
            // Load previously read notes and update UI
            previouslyReadNotes = loadPreviouslyReadNotes()
            updatePreviouslyReadUI()
            
            // Add observers
            NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChange), name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handlePreviouslyReadNotesUpdated), name: NSNotification.Name("PreviouslyReadNotesUpdated"), object: nil)
        }

    // In HomeViewController
    @objc private func handlePreviouslyReadNotesUpdated() {
        previouslyReadNotes = loadPreviouslyReadNotes()
        print("Updated previouslyReadNotes: \(previouslyReadNotes.map { "\($0.id): \($0.title), \($0.lastOpened)" })")
        updatePreviouslyReadUI()
    }
    
    @objc private func handleFavoriteStatusChange() {
        // Refresh the notes when favorite status changes
        fetchNotes()
    }

    deinit {
        // Remove observer when the view controller is deallocated
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("PreviouslyReadNotesUpdated"), object: nil)

    }
    private func updatePreviouslyReadUI() {
            if previouslyReadNotes.isEmpty {
                previouslyReadCollectionView.isHidden = true
                previouslyReadPlaceholderView.isHidden = false
            } else {
                previouslyReadCollectionView.isHidden = false
                previouslyReadPlaceholderView.isHidden = true
                previouslyReadCollectionView.reloadData()
                previouslyReadCollectionView.collectionViewLayout.invalidateLayout() // Force layout refresh
            }
        }

    // MARK: - Setup
    private func setupUI() {
            view.backgroundColor = .systemBackground
            
            // Add header view
            view.addSubview(headerView)
            headerView.addSubview(headerLabel)
            headerView.addSubview(profileButton)
            
            // Add scroll view and content view
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            
            // Add UI components to the content view
            [notesLabel, notesCollectionView, previouslyReadLabel, previouslyReadCollectionView,
             previouslyReadPlaceholderView, collegesLabel, collegesCollectionView].forEach {
                contentView.addSubview($0)
            }
            
            // Add placeholder label to placeholder view
            previouslyReadPlaceholderView.addSubview(placeholderLabel)
            
            // Add activity indicator
            notesCollectionView.addSubview(activityIndicator)
            
            // Constraints for header view (unchanged)
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                headerView.heightAnchor.constraint(equalToConstant: 40),
                
                headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                
                profileButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                profileButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                profileButton.widthAnchor.constraint(equalToConstant: 40),
                profileButton.heightAnchor.constraint(equalToConstant: 40),
            ])
            
            // Constraints for scroll view and content view (unchanged)
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            ])
            
            // Constraints for other UI components
            NSLayoutConstraint.activate([
                notesLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                notesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                notesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                notesCollectionView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 16),
                notesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                notesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                notesCollectionView.heightAnchor.constraint(equalToConstant: 280),
                
                previouslyReadLabel.topAnchor.constraint(equalTo: notesCollectionView.bottomAnchor, constant: 24),
                previouslyReadLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                previouslyReadLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                previouslyReadCollectionView.topAnchor.constraint(equalTo: previouslyReadLabel.bottomAnchor, constant: 8),
                previouslyReadCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                previouslyReadCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                previouslyReadCollectionView.heightAnchor.constraint(equalToConstant: 150), // Increased to 150
                
                previouslyReadPlaceholderView.topAnchor.constraint(equalTo: previouslyReadLabel.bottomAnchor, constant: 8),
                previouslyReadPlaceholderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                previouslyReadPlaceholderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                previouslyReadPlaceholderView.heightAnchor.constraint(equalToConstant: 100),
                
                placeholderLabel.centerXAnchor.constraint(equalTo: previouslyReadPlaceholderView.centerXAnchor),
                placeholderLabel.centerYAnchor.constraint(equalTo: previouslyReadPlaceholderView.centerYAnchor),
                placeholderLabel.leadingAnchor.constraint(greaterThanOrEqualTo: previouslyReadPlaceholderView.leadingAnchor, constant: 16),
                placeholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: previouslyReadPlaceholderView.trailingAnchor, constant: -16),
                
                collegesLabel.topAnchor.constraint(equalTo: previouslyReadCollectionView.bottomAnchor, constant: 24),
                collegesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                collegesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                collegesCollectionView.topAnchor.constraint(equalTo: collegesLabel.bottomAnchor, constant: 16),
                collegesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                collegesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                collegesCollectionView.heightAnchor.constraint(equalToConstant: 312),
                collegesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
                
                activityIndicator.centerXAnchor.constraint(equalTo: notesCollectionView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: notesCollectionView.centerYAnchor)
            ])
        }
    
    private func setupDelegates() {
        notesCollectionView.dataSource = self
        notesCollectionView.delegate = self
        previouslyReadCollectionView.dataSource = self
        previouslyReadCollectionView.delegate = self
        collegesCollectionView.dataSource = self
        collegesCollectionView.delegate = self
    }
    
    private func fetchNotes() {
        isLoading = true
        activityIndicator.startAnimating()
        
        FirebaseService.shared.fetchNotes { [weak self] fetchedNotes, _ in
            guard let self = self else { return }
            self.notes = fetchedNotes
            print("Home: Fetched \(fetchedNotes.count) notes")
            
            FirebaseService.shared.fetchRecommendedNotes { recommendedNotes in
                self.recommendedNotes = recommendedNotes
                print("Home: Updated recommended notes, count: \(recommendedNotes.count)")
                recommendedNotes.forEach { note in
                    print("Home Note \(note.id): isFavorite = \(note.isFavorite)")
                }
                self.notesCollectionView.reloadData()
                self.activityIndicator.stopAnimating()
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Previously Read Notes Storage
    private func savePreviouslyReadNote(_ note: PreviouslyReadNote) {
            guard let userId = FirebaseService.shared.currentUserId else { return }
            var history = loadPreviouslyReadNotes()
            
            history.removeAll { $0.id == note.id }
            history.append(note)
            history.sort { $0.lastOpened > $1.lastOpened }
            if history.count > 5 {
                history = Array(history.prefix(5))
            }
            
        let historyData = history.map { [
            "id": $0.id,
            "title": $0.title,
            "pdfUrl": $0.pdfUrl,
            "lastOpened": $0.lastOpened.timeIntervalSince1970 // Convert Date to TimeInterval
        ]}
        UserDefaults.standard.set(historyData, forKey: "previouslyReadNotes_\(userId)")
        
        NotificationCenter.default.post(name: NSNotification.Name("PreviouslyReadNotesUpdated"), object: nil)
        }

        private func loadPreviouslyReadNotes() -> [PreviouslyReadNote] {
            guard let userId = FirebaseService.shared.currentUserId else { return [] }
            guard let historyData = UserDefaults.standard.array(forKey: "previouslyReadNotes_\(userId)") as? [[String: Any]] else {
                return []
            }
            
            return historyData.compactMap { dict in
                guard let id = dict["id"] as? String,
                      let title = dict["title"] as? String,
                      let pdfUrl = dict["pdfUrl"] as? String,
                      let lastOpenedTimestamp = dict["lastOpened"] as? TimeInterval else { return nil }
                
                return PreviouslyReadNote(id: id, title: title, pdfUrl: pdfUrl, lastOpened: Date(timeIntervalSince1970: lastOpenedTimestamp))
            }
        }
    
    @objc private func profileButtonTapped() {
        let profileVC = ProfileViewController()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == notesCollectionView {
                return recommendedNotes.count
            } else if collectionView == previouslyReadCollectionView {
                return previouslyReadNotes.count
            } else {
                return colleges.count
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.7
        return CGSize(width: width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == notesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noteReuseIdentifier, for: indexPath) as! NoteCollectionViewCell
            let note = recommendedNotes[indexPath.item]
            cell.configure(with: note)
            
            // Handle favorite button tap
            cell.favoriteButtonTapped = { [weak self] in
                guard let self = self else { return }
                let newFavoriteStatus = !note.isFavorite
                cell.isFavorite = newFavoriteStatus
                self.recommendedNotes[indexPath.item].isFavorite = newFavoriteStatus
                FirebaseService.shared.updateFavoriteStatus(for: note.id, isFavorite: newFavoriteStatus) { success in
                    if (success == nil) {
                        DispatchQueue.main.async {
                            cell.isFavorite = !newFavoriteStatus
                            self.recommendedNotes[indexPath.item].isFavorite = !newFavoriteStatus
                        }
                    }
                }
            }
            return cell
        } else if collectionView == previouslyReadCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noteReuseIdentifier, for: indexPath) as! NoteCollectionViewCell
            let previouslyReadNote = previouslyReadNotes[indexPath.item]
            
            // Find the full note details if available
            let fullNote = recommendedNotes.first(where: { $0.id == previouslyReadNote.id })
            cell.configureForPreviouslyRead(with: previouslyReadNote, fullNote: fullNote)
            
            // Debug frame after configuration
            DispatchQueue.main.async {
                print("Cell \(indexPath.item) frames: title=\(cell.titleLabel.frame), subject=\(cell.subjectNameLabel.frame), date=\(cell.lastOpenedDateLabel.frame)")
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collegeReuseIdentifier, for: indexPath) as! CollegeCell
            cell.configure(with: colleges[indexPath.item])
            return cell
        }
    }
    }



extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                }
            }
        }

        if collectionView == collegesCollectionView {
            let selectedCollege = colleges[indexPath.item]
            Task { @MainActor in
                do {
                    activityIndicator.startAnimating()
                    collectionView.isUserInteractionEnabled = false // Disable taps during fetch

                    let (_, groupedNotes) = try await FirebaseService.shared.fetchNotes()

                    activityIndicator.stopAnimating()
                    collectionView.isUserInteractionEnabled = true // Re-enable taps

                    if let collegeNotes = groupedNotes[selectedCollege.name] {
                        let notesVC = NotesViewController()
                        notesVC.configure(with: collegeNotes)
                        navigationController?.pushViewController(notesVC, animated: true)
                    } else {
                        showAlert(title: "No Notes", message: "No notes available for \(selectedCollege.name).")
                    }
                } catch {
                    activityIndicator.stopAnimating()
                    collectionView.isUserInteractionEnabled = true
                    showAlert(title: "Error", message: "Failed to fetch notes: \(error.localizedDescription)")
                }
            }
            } else if collectionView == notesCollectionView {
                let selectedNote = recommendedNotes[indexPath.item]
                print("Selected note with pdfUrl: \(selectedNote.pdfUrl)")
                showLoadingAlert {
                    FirebaseService.shared.downloadPDF(from: selectedNote.pdfUrl) { [weak self] result in
                        DispatchQueue.main.async {
                            self?.dismissLoadingAlert {
                                switch result {
                                case .success(let url):
                                    print("Opening PDF at \(url.path)")
                                    let pdfVC = PDFViewerViewController(pdfURL: url, title: selectedNote.title)
                                    let nav = UINavigationController(rootViewController: pdfVC)
                                    nav.modalPresentationStyle = .fullScreen
                                    self?.present(nav, animated: true)
                                    
                                    // Update previously read notes
                                    let previouslyReadNote = PreviouslyReadNote(
                                        id: selectedNote.id,
                                        title: selectedNote.title,
                                        pdfUrl: selectedNote.pdfUrl,
                                        lastOpened: Date()
                                    )
                                    self?.savePreviouslyReadNote(previouslyReadNote)
                                    self?.previouslyReadNotes = self?.loadPreviouslyReadNotes() ?? []
                                    self?.previouslyReadCollectionView.reloadData()
                                case .failure(let error):
                                    self?.showAlert(title: "Error", message: "Could not load PDF: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            } else if collectionView == previouslyReadCollectionView {
                let selectedNote = previouslyReadNotes[indexPath.item]
                showLoadingAlert {
                    FirebaseService.shared.downloadPDF(from: selectedNote.pdfUrl) { [weak self] result in
                        DispatchQueue.main.async {
                            self?.dismissLoadingAlert {
                                switch result {
                                case .success(let url):
                                    print("Opening PDF at \(url.path)")
                                    let pdfVC = PDFViewerViewController(pdfURL: url, title: selectedNote.title)
                                    let nav = UINavigationController(rootViewController: pdfVC)
                                    nav.modalPresentationStyle = .fullScreen
                                    self?.present(nav, animated: true)
                                    
                                    // Update previously read notes
                                    let updatedNote = PreviouslyReadNote(
                                        id: selectedNote.id,
                                        title: selectedNote.title,
                                        pdfUrl: selectedNote.pdfUrl,
                                        lastOpened: Date()
                                    )
                                    self?.savePreviouslyReadNote(updatedNote)
                                    self?.previouslyReadNotes = self?.loadPreviouslyReadNotes() ?? []
                                    self?.previouslyReadCollectionView.reloadData()
                                case .failure(let error):
                                    self?.showAlert(title: "Error", message: "Could not load PDF: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
        }
    
    // Helper methods for loading alert
    private func showLoadingAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: "Loading PDF...", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        alert.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor, constant: 20)
        ])
        present(alert, animated: true, completion: completion)
    }

    private func dismissLoadingAlert(completion: @escaping () -> Void) {
        dismiss(animated: true, completion: completion)
    }

    // Add this helper method if not already present
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
