//
//  HomeView.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 24.06.25.
//

import UIKit

class HomeView: UIView {
    enum Section: Int, CaseIterable {
        case main
        case footer
    }
    
    enum PhotoSectionItem: Hashable {
        case photo(Photo)
        case loadingIndicator
    }
    
    private let reuseIdentifier = "PhotoCell"
    private let loadingReuseIdentifier = "LoadingCell"
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoSectionItem>!
    
    private var isLoadingMore = false
    
    weak var collectionViewPrefetchDataSource: UICollectionViewDataSourcePrefetching? {
        get { collectionView.prefetchDataSource }
        set { collectionView.prefetchDataSource = newValue }
    }
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.register(LoadingFooterCell.self, forCellWithReuseIdentifier: loadingReuseIdentifier)
        return cv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup views
    
    fileprivate func setupView() {
        addSubview(collectionView)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    fileprivate func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, PhotoSectionItem>(
            collectionView: collectionView
        ) { (collectionView, indexPath, item) in
            switch item {
            case .photo(let photo):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: self.reuseIdentifier,
                    for: indexPath
                ) as? PhotoCell else {
                    fatalError("Could not create PhotoCell")
                }
                cell.configure(with: photo)
                return cell
            case .loadingIndicator:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: self.loadingReuseIdentifier,
                    for: indexPath
                ) as? LoadingFooterCell else {
                    fatalError("Could not create LoadingCell")
                }
                cell.activityIndicator.startAnimating()
                return cell
            }
        }
    }
    
    // MARK: - Update UI methods
    
    func update(with photos: [Photo], isLoadingMore: Bool) {
        self.isLoadingMore = isLoadingMore
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoSectionItem>()
        snapshot.appendSections([.main])
        
        let photoItems = photos.map { PhotoSectionItem.photo($0) }
        snapshot.appendItems(photoItems, toSection: .main)
        
        if isLoadingMore {
            snapshot.appendSections([.footer])
            snapshot.appendItems([.loadingIndicator], toSection: .footer)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func showActivityIndicator(_ show: Bool) {
        if show {
            bringSubviewToFront(activityIndicator)
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

}

extension HomeView {
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            switch sectionKind {
            case .main:
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
                return section
                
            case .footer:
                let size = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(45)
                )
                let item = NSCollectionLayoutItem(layoutSize: size)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
    }
}
