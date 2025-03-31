//
//  AppSearchController.swift
//  AppStore
//
//  Created by Dmitry Volkov on 26/03/2025.
//

import UIKit
import SDWebImage

class AppSearchController: UICollectionViewController, UISearchBarDelegate {
    var timer: Timer?
    
    // 2
    let cellId = "cell"
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var appResults = [Result]()
    
    private let emptySearchLabel: UILabel = {
        let label = UILabel()
        label.text = "Please, enter search term above..."
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = . gray
        
        // 3 UICollectionViewCell.self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        setupSearchBar()
        collectionView.addSubview(emptySearchLabel)
        setConstraints()
    }
    
    
    func fetchData(with searchTerm: String = "Instagram") {
        NetworkService.shared.fetchApps(searchTerm: searchTerm) { (result, err) in
            if let err {
                print("Failed to fetch", err)
                return
            }
            
            self.appResults = result
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.fetchData(with: searchText)
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            emptySearchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptySearchLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // 4
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptySearchLabel.isHidden = appResults.count != 0
        return appResults.count
    }
    
    // 1
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        cell.configure(with: appResults[indexPath.item])
        
        return cell
    }
    
    
    // 0
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// 6
extension AppSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: view.frame.width - 32, height: 100)
        return .init(width: view.frame.width, height: 370)
    }
}

