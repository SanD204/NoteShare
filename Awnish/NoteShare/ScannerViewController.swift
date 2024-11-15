
//  ScannerViewController.swift
//  NoteShare
//  Created by admin69 Awnish on 14/11/24.
import VisionKit
import PDFKit
import UniformTypeIdentifiers

class ScannerViewController: UIViewController {
    private var scannedDocuments: [ScannedDocument] = []
    private let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Scanner"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Scan Document", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let importButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Import PDF", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemGray5
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 48) / 2, height: 200)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupActions()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        [headerLabel, scanButton, importButton, collectionView].forEach {
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            scanButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            scanButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            scanButton.heightAnchor.constraint(equalToConstant: 50),
            
            importButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            importButton.leadingAnchor.constraint(equalTo: scanButton.trailingAnchor, constant: 12),
            importButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            importButton.heightAnchor.constraint(equalToConstant: 50),
            importButton.widthAnchor.constraint(equalTo: scanButton.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ScannedDocumentCell.self, forCellWithReuseIdentifier: "ScannedDocumentCell")
    }
    
    private func setupActions() {
            scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
            importButton.addTarget(self, action: #selector(importButtonTapped), for: .touchUpInside)
            documentPicker.delegate = self
            
            // Load saved documents on startup
            loadSavedDocuments()
        }
        
        // MARK: - Actions
        @objc private func scanButtonTapped() {
            guard VNDocumentCameraViewController.isSupported else {
                showAlert(title: "Not Supported", message: "Document scanning is not available on this device.")
                return
            }
            
            let scannerViewController = VNDocumentCameraViewController()
            scannerViewController.delegate = self
            present(scannerViewController, animated: true)
        }
        
        @objc private func importButtonTapped() {
            present(documentPicker, animated: true)
        }
        
        // MARK: - Document Management
        private func loadSavedDocuments() {
            guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(
                    at: documentsPath,
                    includingPropertiesForKeys: [.creationDateKey],
                    options: .skipsHiddenFiles
                )
                
                let pdfURLs = fileURLs.filter { $0.pathExtension.lowercased() == "pdf" }
                
                scannedDocuments = pdfURLs.compactMap { url in
                    guard let pdfDocument = PDFDocument(url: url) else { return nil }
                    
                    let thumbnail = pdfDocument.page(at: 0)?.thumbnail(of: CGSize(width: 200, height: 200), for: .mediaBox) ?? UIImage()
                    
                    return ScannedDocument(
                        title: url.deletingPathExtension().lastPathComponent,
                        pdfUrl: url,
                        thumbnailImage: thumbnail,
                        dateCreated: (try? url.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date(),
                        numberOfPages: pdfDocument.pageCount
                    )
                }
                
                // Sort by date, newest first
                scannedDocuments.sort { $0.dateCreated > $1.dateCreated }
                collectionView.reloadData()
                
            } catch {
                print("Error loading documents: \(error)")
            }
        }
        
        private func saveScannedDocument(from scan: VNDocumentCameraScan) {
            // Create PDF from scanned pages
            let pdfDocument = PDFDocument()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
            
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                guard let page = PDFPage(image: image) else { continue }
                pdfDocument.insert(page, at: pageIndex)
            }
            
            // Generate unique filename
            let fileName = "Scan_\(dateFormatter.string(from: Date())).pdf"
            guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let pdfUrl = documentsPath.appendingPathComponent(fileName)
            
            guard pdfDocument.write(to: pdfUrl) else {
                showAlert(title: "Error", message: "Failed to save the scanned document.")
                return
            }
            
            // Create thumbnail from first page
            let thumbnail = scan.imageOfPage(at: 0)
            
            // Create and add new document
            let document = ScannedDocument(
                title: fileName.replacingOccurrences(of: ".pdf", with: ""),
                pdfUrl: pdfUrl,
                thumbnailImage: thumbnail,
                numberOfPages: scan.pageCount
            )
            
            scannedDocuments.insert(document, at: 0)
            collectionView.reloadData()
        }
        
        private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    // MARK: - VNDocumentCameraViewControllerDelegate
    extension ScannerViewController: VNDocumentCameraViewControllerDelegate {
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true) {
                self.saveScannedDocument(from: scan)
            }
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true) {
                self.showAlert(title: "Scanning Failed", message: error.localizedDescription)
            }
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }
    }

    // MARK: - UIDocumentPickerDelegate
    extension ScannerViewController: UIDocumentPickerDelegate {
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedUrl = urls.first,
                  let pdfDocument = PDFDocument(url: selectedUrl) else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
            let fileName = "Import_\(dateFormatter.string(from: Date())).pdf"
            
            guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let destinationUrl = documentsPath.appendingPathComponent(fileName)
            
            do {
                // Copy PDF to app's documents directory
                try FileManager.default.copyItem(at: selectedUrl, to: destinationUrl)
                
                // Create thumbnail from first page
                let thumbnail = pdfDocument.page(at: 0)?.thumbnail(of: CGSize(width: 200, height: 200), for: .mediaBox) ?? UIImage()
                
                // Create and add new document
                let document = ScannedDocument(
                    title: fileName.replacingOccurrences(of: ".pdf", with: ""),
                    pdfUrl: destinationUrl,
                    thumbnailImage: thumbnail,
                    numberOfPages: pdfDocument.pageCount
                )
                
                scannedDocuments.insert(document, at: 0)
                collectionView.reloadData()
                
            } catch {
                showAlert(title: "Import Failed", message: error.localizedDescription)
            }
        }
    }

    // MARK: - UICollectionViewDataSource
    extension ScannerViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return scannedDocuments.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScannedDocumentCell", for: indexPath) as? ScannedDocumentCell else {
                return UICollectionViewCell()
            }
            
            let document = scannedDocuments[indexPath.item]
            cell.configure(with: document)
            return cell
        }
    }

    // MARK: - UICollectionViewDelegate
    extension ScannerViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let document = scannedDocuments[indexPath.item]
            let previewController = PDFViewController(document: document)
            navigationController?.pushViewController(previewController, animated: true)
        }
        
        func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            let document = scannedDocuments[indexPath.item]
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let rename = UIAction(title: "Rename", image: UIImage(systemName: "pencil")) { [weak self] _ in
                    self?.showRenameAlert(for: document, at: indexPath)
                }
                
                let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                    self?.shareDocument(document)
                }
                
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                    self?.deleteDocument(at: indexPath)
                }
                
                return UIMenu(children: [rename, share, delete])
            }
        }
        
        private func showRenameAlert(for document: ScannedDocument, at indexPath: IndexPath) {
            let alert = UIAlertController(title: "Rename Document", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.text = document.title
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
                guard let newTitle = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !newTitle.isEmpty else { return }
                
                self?.renameDocument(document, to: newTitle, at: indexPath)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(renameAction)
            present(alert, animated: true)
        }
        
        private func renameDocument(_ document: ScannedDocument, to newTitle: String, at indexPath: IndexPath) {
            let newFileName = "\(newTitle).pdf"
            let newUrl = document.pdfUrl.deletingLastPathComponent().appendingPathComponent(newFileName)
            
            do {
                try FileManager.default.moveItem(at: document.pdfUrl, to: newUrl)
                
                let updatedDocument = ScannedDocument(
                    id: document.id,
                    title: newTitle,
                    pdfUrl: newUrl,
                    thumbnailImage: document.thumbnailImage,
                    dateCreated: document.dateCreated,
                    numberOfPages: document.numberOfPages
                )
                
                scannedDocuments[indexPath.item] = updatedDocument
                collectionView.reloadItems(at: [indexPath])
                
            } catch {
                showAlert(title: "Rename Failed", message: error.localizedDescription)
            }
        }
        
        private func shareDocument(_ document: ScannedDocument) {
            let activityViewController = UIActivityViewController(
                activityItems: [document.pdfUrl],
                applicationActivities: nil
            )
            
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = view
                popoverController.sourceRect = view.bounds
            }
            
            present(activityViewController, animated: true)
        }
        
        private func deleteDocument(at indexPath: IndexPath) {
            let document = scannedDocuments[indexPath.item]
            
            do {
                try FileManager.default.removeItem(at: document.pdfUrl)
                scannedDocuments.remove(at: indexPath.item)
                collectionView.deleteItems(at: [indexPath])
            } catch {
                showAlert(title: "Delete Failed", message: error.localizedDescription)
            }
        }
    }

    // MARK: - ScannedDocumentCell
    class ScannedDocumentCell: UICollectionViewCell {
        private let thumbnailImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .systemGray6
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textColor = .label
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let pageCountLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12, weight: .regular)
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
            backgroundColor = .systemBackground
            layer.cornerRadius = 12
            layer.borderWidth = 1
            layer.borderColor = UIColor.systemGray5.cgColor
            
            contentView.addSubview(thumbnailImageView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(pageCountLabel)
            
            NSLayoutConstraint.activate([
                thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                thumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
                
                titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                
                pageCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                pageCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                pageCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])
        }
        
        func configure(with document: ScannedDocument) {
            thumbnailImageView.image = document.thumbnailImage
            titleLabel.text = document.title
            pageCountLabel.text = "\(document.numberOfPages) page\(document.numberOfPages == 1 ? "" : "s")"
        }
    }
class PDFViewController: UIViewController {
    private let document: ScannedDocument
    private let pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .vertical
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        return pdfView
    }()
    
    init(document: ScannedDocument) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        loadPDF()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(pdfView)
        
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = document.title
        navigationItem.largeTitleDisplayMode = .never
        
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )
        
        let thumbnailButton = UIBarButtonItem(
            image: UIImage(systemName: "square.grid.2x2"),
            style: .plain,
            target: self,
            action: #selector(thumbnailButtonTapped)
        )
        
        navigationItem.rightBarButtonItems = [shareButton, thumbnailButton]
    }
    
    private func loadPDF() {
        if let pdfDocument = PDFDocument(url: document.pdfUrl) {
            pdfView.document = pdfDocument
            
            // Enable search functionality
            pdfView.documentView?.isUserInteractionEnabled = true
            pdfView.usePageViewController(true, withViewOptions: nil)
        } else {
            showErrorAlert()
        }
    }
    
    @objc private func shareButtonTapped() {
        let activityViewController = UIActivityViewController(
            activityItems: [document.pdfUrl],
            applicationActivities: nil
        )
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItems?.first
        }
        
        present(activityViewController, animated: true)
    }
    
    @objc private func thumbnailButtonTapped() {
        let thumbnailViewController = PDFThumbnailViewController(pdfView: pdfView)
        let navigationController = UINavigationController(rootViewController: thumbnailViewController)
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(navigationController, animated: true)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: "Unable to load the PDF document.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - PDFThumbnailViewController
class PDFThumbnailViewController: UIViewController {
    private let pdfView: PDFView
    
    private let thumbnailView: PDFThumbnailView = {
        let view = PDFThumbnailView()
        view.thumbnailSize = CGSize(width: 80, height: 120)
        view.layoutMode = .horizontal
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(pdfView: PDFView) {
        self.pdfView = pdfView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Thumbnails"
        view.backgroundColor = .systemBackground
        
        view.addSubview(thumbnailView)
        thumbnailView.pdfView = pdfView
        
        NSLayoutConstraint.activate([
            thumbnailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            thumbnailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            thumbnailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            thumbnailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Add done button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }
}


#Preview(){
    ScannedDocumentCell()
}
