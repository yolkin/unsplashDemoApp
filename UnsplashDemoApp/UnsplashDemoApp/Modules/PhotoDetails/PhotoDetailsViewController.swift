//
//  PhotoDetailsViewController.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 30.06.25.
//

import UIKit
import Combine

class PhotoDetailsViewController: UIViewController {

    private let detailsView = PhotoDetailsView()
    private let viewModel: PhotoDetailsViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle methods
    
    init(viewModel: PhotoDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureNavigationController()
        setupBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        detailsView.prepareForReuse()
    }
    
    // MARK: - Setup Views
    
    private func setupView() {
        view.addSubview(detailsView)
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.topAnchor),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        detailsView.configure(with: viewModel)
    }
    
    private func configureNavigationController() {
        navigationItem.largeTitleDisplayMode = .never
        
        let likeButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(likeButtonHandler)
        )
        navigationItem.rightBarButtonItem = likeButton
    }
    
    private func setupBindings() {
        viewModel.isLikedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLiked in
                let imageName = isLiked ? "heart.fill" : "heart"
                self?.navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
            }
            .store(in: &cancellables)
    }
    
    @objc private func likeButtonHandler() {
        viewModel.toggleLike()
        // update favorite photos
    }

}
