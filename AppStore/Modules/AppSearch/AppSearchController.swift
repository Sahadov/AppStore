//
//  AppSearchController.swift
//  AppStore
//
//  Created by Dmitry Volkov on 26/03/2025.
//

import UIKit

class AppSearchController: UICollectionViewController {
    // 2
    let cellId = "cell"
    
    private var appResults = [Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = . gray
        
        // 3 UICollectionViewCell.self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchData()
    }
    
    
    func fetchData() {
        NetworkService.shared.fetchApps { (result, err) in
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
    
    // 4
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appResults.count
    }
    
    // 1
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let app = appResults[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        cell.titleLabel.text = app.trackName
        cell.categoryLabel.text = app.primaryGenreName
        cell.ratingLabel.text = String(format: "%.2f", app.averageUserRating ?? "Not rated yet")
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

