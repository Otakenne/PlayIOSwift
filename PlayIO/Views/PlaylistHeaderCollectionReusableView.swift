//
//  PlaylistHeaderCollectionReusableView.swift
//  PlayIO
//
//  Created by Otakenne on 18/01/2022.
//

import SDWebImage
import UIKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "photo")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        return label
    }()
    
    let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.getColor(colorHex: "#E2374D")
        let image = UIImage(
            systemName: "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30,
                weight: .regular
            )
        )?.withTintColor(.systemBackground, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(playlistImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlayAll() {
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = height / 1.8
        
        playlistImageView.frame = CGRect(
            x: (width - imageSize) / 2,
            y: 20,
            width: imageSize,
            height: imageSize
        )
        
        nameLabel.frame = CGRect(
            x: 20,
            y: playlistImageView.bottom + 30,
            width: width - 100,
            height: 25
        )
        
        descriptionLabel.frame = CGRect(
            x: 20,
            y: nameLabel.bottom,
            width: width - 100,
            height: 44
        )
        
        ownerLabel.frame = CGRect(
            x: 20,
            y: descriptionLabel.bottom,
            width: width - 100,
            height: 15
        )
        
        playAllButton.frame = CGRect(
            x: width - 60,
            y: descriptionLabel.center.y - 25,
            width: 50,
            height: 50)
    }
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        playlistImageView.sd_setImage(with: viewModel.artworkURL, placeholderImage: UIImage(systemName: "photo"), completed: nil)
    }
}
