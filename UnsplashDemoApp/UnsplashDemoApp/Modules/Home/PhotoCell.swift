//
//  PhotoCell.swift
//  UnsplashDemoApp
//
//  Created by Alexander on 24.06.25.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(with photo: Photo) {
        if let url = URL(string: photo.urls.small) {
            imageView.kf.setImage(with: url, options: [
                .cacheOriginalImage
            ])
        } else {
            imageView.image = UIImage(systemName: "photo")?
                .withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        }
    }
    
}
