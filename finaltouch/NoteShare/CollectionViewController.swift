//import UIKit
//class CollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
//    private var filteredItems: [String] = []
//    private var isSearching: Bool = false
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Collection"
//        label.font = .systemFont(ofSize: 32, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "Search"
//        searchBar.searchBarStyle = .minimal
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        return searchBar
//    }()
//    
//    let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()
//
//    let items = ["Saved", "Subjects", "Favourites", "Recents"]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        setupTableView()
//        setupSearchBar()
//        filteredItems = items
//    }
//    
//    private func setupUI() {
//        // Add subviews
//        view.addSubview(titleLabel)
//        view.addSubview(searchBar)
//        view.addSubview(tableView)
//        
//        // Setup layout constraints using the navigation bar height
//        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
//        
//        NSLayoutConstraint.activate([
//            // Adjust title position to account for navigation bar
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -navBarHeight+24),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            
//            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            
//            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
//    
//    func setupSearchBar() {
//        searchBar.delegate = self
//    }
//    
//    func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return isSearching ? filteredItems.count : items.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = isSearching ? filteredItems[indexPath.row] : items[indexPath.row]
//        cell.accessoryType = .disclosureIndicator
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let selectedItem = isSearching ? filteredItems[indexPath.row] : items[indexPath.row]
//        
//        let viewController: UIViewController = {
//            switch selectedItem {
//            case "Saved":
//                return CollectionSavedViewController()
//            case "Subjects":
//                return CollectionSubjectViewController()
//            case "Favourites":
//                return CollectionFavViewController()
//            case "Recents":
//                return CollectionRecentViewController()
//            default:
//                return UIViewController()
//            }
//        }()
//        
//        navigationController?.pushViewController(viewController, animated: true)
//    }
//    
//    // MARK: - SearchBar Delegate Methods
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            filteredItems = items
//            isSearching = false
//            searchBar.resignFirstResponder()
//        } else {
//            filteredItems = items.filter { $0.lowercased().contains(searchText.lowercased()) }
//            isSearching = true
//        }
//        tableView.reloadData()
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        filteredItems = items
//        isSearching = false
//        searchBar.resignFirstResponder()
//        tableView.reloadData()
//    }
//    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = true
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
//    }
//}
//
//#Preview {
//    CollectionViewController()
//}

import UIKit

class CollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private var filteredItems: [String] = []
    private var isSearching: Bool = false
    private var initialLayout = true
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Collection"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let items = ["Saved", "Subjects", "Favourites", "Recents"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
        setupTableView()
        setupSearchBar()
        filteredItems = items
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupUI() {
        // Add container view first
        view.addSubview(containerView)
        
        // Add other views to container
        containerView.addSubview(titleLabel)
        containerView.addSubview(searchBar)
        containerView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // Container view constraints
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Title constraints
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            // Search bar constraints
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            // Table view constraints
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !initialLayout {
            // Only modify navigation bar if not initial layout
            setupNavigationBar()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialLayout = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Reset navigation bar appearance when leaving
        if isMovingFromParent {
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredItems.count : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = isSearching ? filteredItems[indexPath.row] : items[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = isSearching ? filteredItems[indexPath.row] : items[indexPath.row]
        
        let viewController: UIViewController = {
            switch selectedItem {
            case "Saved":
                return CollectionSavedViewController()
            case "Subjects":
                return CollectionSubjectViewController()
            case "Favourites":
                return CollectionFavViewController()
            case "Recents":
                return CollectionRecentViewController()
            default:
                return UIViewController()
            }
        }()
        
        // Configure the next view controller's navigation bar
        viewController.navigationItem.title = selectedItem
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    // MARK: - Search Bar Delegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredItems = items
            isSearching = false
            searchBar.resignFirstResponder()
        } else {
            filteredItems = items.filter { $0.lowercased().contains(searchText.lowercased()) }
            isSearching = true
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredItems = items
        isSearching = false
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}

#Preview {
    CollectionViewController()
}
