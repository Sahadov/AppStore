//
//  AppsViewController.swift
//  AppStore
//
//  Created by Dmitry Volkov on 02/04/2025.
//

import UIKit


final class AppsViewController: UICollectionViewController {
    var groups = [AppGroup]()
    var headerApps = [SocialApp]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: AppsHeaderCell.identifier)
        collectionView.register(AppsRowCell.self, forCellWithReuseIdentifier: AppsRowCell.identifier)
        collectionView.register(LabelHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LabelHeaderView.identifier)
        
        collectionView.contentInset.top = 25
        
        setActivityIndicator()
        fetchData()
        
    }
        
    init() {
        super.init(collectionViewLayout: AppsViewController.createLayout())
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchData() {
        var group1: AppGroup?
        var group2: AppGroup?

        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        NetworkService.shared.fetchSocialApps { (apps, err) in
            dispatchGroup.leave()
            self.headerApps = apps ?? []
        }
        
        dispatchGroup.enter()
        NetworkService.shared.fetchGames { (appGroup, err) in
            dispatchGroup.leave()
            group1 = appGroup
        }
        
        dispatchGroup.enter()
        NetworkService.shared.fetchBestApps { (appGroup, err) in
            dispatchGroup.leave()
            group2 = appGroup
        }
        
        dispatchGroup.enter()
        NetworkService.shared.fetchBestApps { (appGroup, err) in
            dispatchGroup.leave()
            group2 = appGroup
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            
            if let group = group1 {
                self.groups.append(group)
            }
            if let group = group2 {
                self.groups.append(group)
            }
            self.collectionView.reloadData()
        }
    }
}

extension AppsViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return headerApps.count
        } else if section == 1 {
            if groups.indices.contains(0) {
                return groups[0].feed.results.count
            }
            return 0
        }
        if groups.indices.contains(1) {
            return groups[1].feed.results.count
        }
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let app = headerApps[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsHeaderCell.identifier, for: indexPath) as! AppsHeaderCell
            cell.configure(with: app)
            return cell
        } else if indexPath.section == 1 {
            if groups.indices.contains(0) {
                let results = groups[0].feed.results
                let app = results[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsRowCell.identifier, for: indexPath) as! AppsRowCell
                cell.configure(with: app)
                return cell
            }
            return UICollectionViewCell()
        }
        if groups.indices.contains(1) {
            let results = groups[1].feed.results
            let app = results[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsRowCell.identifier, for: indexPath) as! AppsRowCell
            cell.configure(with: app)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return createSection(for: sectionIndex, layoutEnvironment: layoutEnvironment)
        }
    }

    private static func createSection(for sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        if sectionIndex == 0 {
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(0.95),
                    heightDimension: .absolute(300)
                )
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(300)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 0)
            return section


            
        } else if sectionIndex == 1 {
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(80)))
            item.contentInsets.bottom = 10
        
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .estimated(500)
                ),
                subitems: Array(repeating: item, count: 3)
            )
            
            group.interItemSpacing = .fixed(15)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
            
            // header
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(50)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )

            section.boundarySupplementaryItems = [headerItem]
            
            return section
        } else {
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(80)))
            item.contentInsets.bottom = 10
        
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .estimated(500)
                ),
                subitems: Array(repeating: item, count: 3)
            )
            
            group.interItemSpacing = .fixed(15)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
            
            // header
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(50)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )

            section.boundarySupplementaryItems = [headerItem]
            
            return section
        }
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader, indexPath.section == 1 {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LabelHeaderView.identifier,
                for: indexPath
            ) as! LabelHeaderView
            header.label.text = "Editor´s Choice Games"
            return header
        } else if kind == UICollectionView.elementKindSectionHeader, indexPath.section == 2 {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LabelHeaderView.identifier,
                for: indexPath
            ) as! LabelHeaderView
            header.label.text = "Top free apps"
            return header
        }
        return UICollectionReusableView()
    }
    
    func setActivityIndicator() {
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}
