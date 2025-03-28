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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = . gray
        
        // 3 UICollectionViewCell.self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // 4
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    // 1
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
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

