//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 11/08/2023.
//

import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imagesListDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImageListCellDelegate?
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction private func likeButtonClicked() {
        delegate?.imagesListDidTapLike(self)
    }
    func setIsLike(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "LikeButtonOn") : UIImage(named: "LikeButtonOff")
        likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListCell {
    func gradientDateLabel() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.ypBlack.withAlphaComponent(0.2).cgColor, UIColor.ypBlack.withAlphaComponent(0.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = dateLabel.bounds
        dateLabel.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        gradientDateLabel()
    }
}

extension ImagesListCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
}

extension ImagesListCell {
    func configure(with photo: Photo, isLiked: Bool) {
        let imageURL = URL(string: photo.smallImageURL)
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "photos_placeholder")
        )
        dateLabel.text = photo.createdAt.map { CustomDateFormatters.shared.dateFormatter.string(from: $0).replacingOccurrences(of: "г.", with: "")}
        setIsLike(isLiked)
    }
}
