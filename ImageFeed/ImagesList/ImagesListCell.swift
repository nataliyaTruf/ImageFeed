//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 11/08/2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
}

extension ImagesListCell {
    func gradientDateLabel() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.ypBlack.withAlphaComponent(0.2).cgColor, UIColor.ypBlack.withAlphaComponent(0.0).cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = dateLabel.bounds
        dateLabel.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradientDateLabel()
    }
}
