//
//  PhotoDetailsView.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 30.06.25.
//

import UIKit
import Kingfisher

class PhotoDetailsView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let infoStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            infoStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with viewModel: PhotoDetailsViewModelProtocol) {
        if let url = viewModel.imageURL {
            imageView.kf.setImage(with: url) { [weak self] result in
                guard let self else { return }
                if case .success(let imageResult) = result {
                    let ratio = imageResult.image.size.height / imageResult.image.size.width
                    NSLayoutConstraint.activate([
                        imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: ratio)
                    ])
                }
            }
        }
        
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let descriptionLabel = createLabel(text: viewModel.description, style: .headline)
        let createdAtLabel = createLabel(text: viewModel.createdAt, style: .subheadline)
        let authorLabel = createLabel(text: viewModel.author, style: .subheadline)
        let likesLabel = createLabel(text: viewModel.likes, style: .subheadline)
        
        infoStackView.addArrangedSubview(descriptionLabel)
        infoStackView.addArrangedSubview(createdAtLabel)
        infoStackView.addArrangedSubview(authorLabel)
        infoStackView.addArrangedSubview(likesLabel)
    }
    
    func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }

}

extension PhotoDetailsView {
    fileprivate func createLabel(text: String?, style: UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: style)
        label.textColor = style == .headline ? .label : .secondaryLabel
        return label
    }
}
