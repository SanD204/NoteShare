//import UIKit
//
//class UploadModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIDocumentPickerDelegate {
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Upload Here"
//        label.textAlignment = .center
//        label.font = UIFont.boldSystemFont(ofSize: 24)
//        return label
//    }()
//    
//    let categoryTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Select the category"
//        textField.borderStyle = .roundedRect
//        return textField
//    }()
//    
//    let fileNameTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter the name of file"
//        textField.borderStyle = .roundedRect
//        return textField
//    }()
//    
//    let uploadCardView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
//        view.backgroundColor = .systemGray6
//        return view
//    }()
//    
//    let uploadImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "icloud.and.arrow.up")
//        imageView.contentMode = .scaleAspectFit
//        imageView.tintColor = .systemBlue
//        return imageView
//    }()
//    
//    let selectFileButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Select File", for: .normal)
//        button.setTitleColor(.systemBlue, for: .normal)
//        button.backgroundColor = .clear
//        return button
//    }()
//    
//    let segmentedControl: UISegmentedControl = {
//        let control = UISegmentedControl(items: ["Private", "Friends", "Public"])
//        control.selectedSegmentIndex = 0
//        return control
//    }()
//    
//    let uploadButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Upload", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .systemBlue
//        button.layer.cornerRadius = 10
//        return button
//    }()
//    
//    let cancelButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Cancel", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .systemRed
//        button.layer.cornerRadius = 10
//        return button
//    }()
//    
//    var pickerView = UIPickerView()
//    let categories = ["AI", "Data Science", "Machine Learning", "Deep Learning", "Python", "Java", "C++", "Web Development", "Android", "iOS"]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 16
//        view.layer.masksToBounds = true
//        setupUI()
//        
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        categoryTextField.inputView = pickerView
//        
//        selectFileButton.addTarget(self, action: #selector(selectFileButtonTapped), for: .touchUpInside)
//        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
//        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
//    }
//    
//    private func setupUI() {
//        [titleLabel, categoryTextField, fileNameTextField, uploadCardView, segmentedControl, uploadButton, cancelButton].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview($0)
//        }
//        
//        [uploadImageView, selectFileButton].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            uploadCardView.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            categoryTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            fileNameTextField.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 20),
//            fileNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            fileNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            uploadCardView.topAnchor.constraint(equalTo: fileNameTextField.bottomAnchor, constant: 20),
//            uploadCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            uploadCardView.widthAnchor.constraint(equalToConstant: 150),
//            uploadCardView.heightAnchor.constraint(equalToConstant: 120),
//            
//            uploadImageView.topAnchor.constraint(equalTo: uploadCardView.topAnchor, constant: 10),
//            uploadImageView.centerXAnchor.constraint(equalTo: uploadCardView.centerXAnchor),
//            uploadImageView.widthAnchor.constraint(equalToConstant: 50),
//            uploadImageView.heightAnchor.constraint(equalToConstant: 50),
//            
//            selectFileButton.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 10),
//            selectFileButton.centerXAnchor.constraint(equalTo: uploadCardView.centerXAnchor),
//            
//            segmentedControl.topAnchor.constraint(equalTo: uploadCardView.bottomAnchor, constant: 20),
//            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            uploadButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
//            uploadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            uploadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            uploadButton.heightAnchor.constraint(equalToConstant: 50),
//            
//            cancelButton.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 10),
//            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            cancelButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return categories.count
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return categories[row]
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        categoryTextField.text = categories[row]
//        view.endEditing(true)
//    }
//    
//    @objc private func selectFileButtonTapped() {
//        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.data])
//        documentPicker.delegate = self
//        present(documentPicker, animated: true, completion: nil)
//    }
//    
//    @objc private func uploadButtonTapped() {
//        let alert = UIAlertController(title: "Success", message: "File uploaded successfully!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//    
//    @objc private func cancelButtonTapped() {
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//// just for example
//class MainViewController: UIViewController {
//    
//    private let uploadButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Open Upload", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .systemBlue
//        button.layer.cornerRadius = 10
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        setupUI()
//        
//        uploadButton.addTarget(self, action: #selector(openUploadModal), for: .touchUpInside)
//    }
//    
//    private func setupUI() {
//        uploadButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(uploadButton)
//        
//        NSLayoutConstraint.activate([
//            uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            uploadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            uploadButton.widthAnchor.constraint(equalToConstant: 200),
//            uploadButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//    
//    @objc private func openUploadModal() {
//        let uploadVC = UploadModalViewController()
//        uploadVC.modalPresentationStyle = .pageSheet
//        if let sheet = uploadVC.sheetPresentationController {
//            sheet.detents = [.custom { context in
//                return context.maximumDetentValue * 0.7
//            }]
//            sheet.prefersGrabberVisible = true
//        }
//        present(uploadVC, animated: true, completion: nil)
//    }
//}
//
//#Preview(){
//    MainViewController()
//}


import UIKit

class BottomSheetPresentationController: UIPresentationController {
    private let blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.alpha = 0
        return view
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let height = containerView.frame.height * 0.7
        return CGRect(x: 0,
                     y: containerView.frame.height - height,
                     width: containerView.frame.width,
                     height: height)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        blurEffectView.frame = containerView.bounds
        containerView.insertSubview(blurEffectView, at: 0)
        
        presentedView?.layer.cornerRadius = 20
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedView?.clipsToBounds = true
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            blurEffectView.alpha = 0.5
            return
        }
        
        coordinator.animate { _ in
            self.blurEffectView.alpha = 0.5
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            blurEffectView.alpha = 0
            return
        }
        
        coordinator.animate { _ in
            self.blurEffectView.alpha = 0
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView?.bounds ?? .zero
    }
}

// MARK: - Bottom Sheet Transition Delegate
class BottomSheetTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - Upload Modal View Controller
class UploadModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIDocumentPickerDelegate {
    private let transitionDelegate = BottomSheetTransitionDelegate()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Upload Here"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select the category"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let fileNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter the name of file"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let uploadCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .systemGray6
        return view
    }()
    
    let uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "icloud.and.arrow.up")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    let selectFileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select File", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Private", "Friends", "Public"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        return button
    }()
    
    var pickerView = UIPickerView()
    let categories = ["AI", "Data Science", "Machine Learning", "Deep Learning", "Python", "Java", "C++", "Web Development", "Android", "iOS"]
    
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupDelegates()
        setupActions()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        [titleLabel, categoryTextField, fileNameTextField, uploadCardView, segmentedControl, uploadButton, cancelButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [uploadImageView, selectFileButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            uploadCardView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoryTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            fileNameTextField.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 20),
            fileNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fileNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            uploadCardView.topAnchor.constraint(equalTo: fileNameTextField.bottomAnchor, constant: 20),
            uploadCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadCardView.widthAnchor.constraint(equalToConstant: 150),
            uploadCardView.heightAnchor.constraint(equalToConstant: 120),
            
            uploadImageView.topAnchor.constraint(equalTo: uploadCardView.topAnchor, constant: 10),
            uploadImageView.centerXAnchor.constraint(equalTo: uploadCardView.centerXAnchor),
            uploadImageView.widthAnchor.constraint(equalToConstant: 50),
            uploadImageView.heightAnchor.constraint(equalToConstant: 50),
            
            selectFileButton.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 10),
            selectFileButton.centerXAnchor.constraint(equalTo: uploadCardView.centerXAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: uploadCardView.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            uploadButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            uploadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            uploadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            uploadButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupDelegates() {
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
    }
    
    private func setupActions() {
        selectFileButton.addTarget(self, action: #selector(selectFileButtonTapped), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UIPickerView Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row]
        view.endEditing(true)
    }
    
    // MARK: - Action Methods
    @objc private func selectFileButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.data])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    @objc private func uploadButtonTapped() {
        let alert = UIAlertController(title: "Success", message: "File uploaded successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Usage in FavouriteViewController



#Preview{
    UploadModalViewController()
}
