import PDFKit

class PDFViewerViewController: UIViewController {
    private var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        return pdfView
    }()
    
    private let pdfURL: URL
    private let initialPage: Int 
    init(pdfURL: URL, initialPage: Int = 0) {
        self.pdfURL = pdfURL
        self.initialPage = initialPage
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPDF()
    }
    
    private func setupUI() {
        pdfView = PDFView(frame: view.bounds)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        view.addSubview(pdfView)
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        }
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadPDF() {
        guard let document = PDFDocument(url: pdfURL) else {
            return
        }
        pdfView.document = document
        
        let pageCount = document.pageCount
        if initialPage < pageCount, initialPage >= 0 {
            if let page = document.page(at: initialPage) {
                pdfView.go(to: page)
            }
        }
    }
}
