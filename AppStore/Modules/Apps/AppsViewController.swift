//
//  AppsViewController.swift
//  AppStore
//
//  Created by Dmitry Volkov on 02/04/2025.
//

import UIKit


final class AppsViewController: UICollectionViewController {
    var editorsChoiceGames: AppGroup?
    var topApps: AppGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: AppsHeaderCell.identifier)
        collectionView.register(AppsRowCell.self, forCellWithReuseIdentifier: AppsRowCell.identifier)
        collectionView.register(LabelHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LabelHeaderView.identifier)
        
        collectionView.contentInset.top = 25
        
        fetchData()
        fetchDataApps()
        
    }
        
    init() {
        super.init(collectionViewLayout: AppsViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchData() {
        NetworkService.shared.fetchGames { (appGroup, err) in
            if let err = err {
                print("Failed to fetch games:", err)
                return
            }
            
            self.editorsChoiceGames = appGroup
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchDataApps() {
        NetworkService.shared.fetchBestApps { (appGroup, err) in
            if let err = err {
                print("Failed to fetch games:", err)
                return
            }
            
            self.topApps = appGroup
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension AppsViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        } else if section == 1 {
            return editorsChoiceGames?.feed.results.count ?? 0
        }
        return 10
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsHeaderCell.identifier, for: indexPath) as! AppsHeaderCell

            return cell
        } else if indexPath.section == 1 {
            guard let app = editorsChoiceGames?.feed.results[indexPath.item] else {
                        return UICollectionViewCell() // fallback
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsRowCell.identifier, for: indexPath) as! AppsRowCell
            cell.configure(with: app)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsRowCell.identifier, for: indexPath) as! AppsRowCell
        return cell
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
            section.orthogonalScrollingBehavior = .continuous
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
            section.orthogonalScrollingBehavior = .continuous
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
            section.orthogonalScrollingBehavior = .continuous
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
}
