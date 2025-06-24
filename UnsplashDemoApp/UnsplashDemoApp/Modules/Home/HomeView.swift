//
//  HomeView.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 24.06.25.
//

import UIKit

class HomeView: UIView {
    enum Section {
        case main
    }
    
    private let reuseIdentifier = "PhotoCell"
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    fileprivate func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(
            collectionView: collectionView
        ) { [weak self] (collectionView, indexPath, photo) in
            guard let self,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "PhotoCell",
                    for: indexPath
                  ) as? PhotoCell else {
                fatalError("Could not create new cell")
            }
            cell.configure(with: photo)
            return cell
        }
    }
    
    func update(with photos: [Photo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

extension HomeView {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.6)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
