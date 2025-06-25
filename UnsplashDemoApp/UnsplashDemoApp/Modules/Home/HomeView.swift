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
    }
    
    private let reuseIdentifier = "PhotoCell"
    private let loadingReuseIdentifier = "LoadingView"
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    
    weak var collectionViewPrefetchDataSource: UICollectionViewDataSourcePrefetching? {
        get { collectionView.prefetchDataSource }
        set { collectionView.prefetchDataSource = newValue }
    }
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.register(
            LoadingFooterReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: loadingReuseIdentifier
            
        )
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
        dataSource = UICollectionViewDiffableDataSource
        <Section, Photo>(collectionView: collectionView) { [weak self] (collectionView, indexPath, photo) in
            guard let self,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                  ) as? PhotoCell else {
                fatalError("Cannot create photo cell")
            }
            cell.configure(with: photo)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self,
                  kind == UICollectionView.elementKindSectionFooter,
                  let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: loadingReuseIdentifier,
                    for: indexPath
                  ) as? LoadingFooterReusableView else {
                return nil
            }
            return footer
        }
    }
    
    // MARK: - Update UI methods
    
    func update(with photos: [Photo], isLoadingMore: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos, toSection: .main)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            dataSource.apply(snapshot, animatingDifferences: true)
            
            if let footer = collectionView.supplementaryView(
                forElementKind: UICollectionView.elementKindSectionFooter,
                at: IndexPath(item: 0, section: 0)
            ) as? LoadingFooterReusableView {
                isLoadingMore ? footer.startAnimating() : footer.stopAnimating()
            }
        }
    }
    
    func showActivityIndicator(_ show: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if show {
                bringSubviewToFront(activityIndicator)
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
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
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        section.boundarySupplementaryItems = [footer]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
