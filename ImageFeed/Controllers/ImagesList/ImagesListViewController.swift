//
//  ViewController.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 27/07/2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private(set) var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var isInitialDataLoaded = false
    private var imagesListServiceObserver: NSObjectProtocol?
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesListObserve()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let photo = photos[indexPath.row]
            if let fullImageURL = URL(string: photo.largeImageURL) {
                viewController.fullImageURL = fullImageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        if let imageURL = URL(string: photo.thumbImageURL) {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "photos_placeholder"),
                completionHandler: { _ in
                    self.tableView.reloadRows(at:[indexPath], with: .automatic)
                }
            )
        }
        if let date = imagesListService.photos[indexPath.row].createdAt {
            cell.dateLabel.text = dateFormatterUtil.string(from: date as Date).replacingOccurrences(of: "г.", with: "")
        } else {
            cell.dateLabel.text = ""
        }
        let isLiked = imagesListService.photos[indexPath.row].isLiked
        cell.setIsLike(isLiked)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

private extension ImagesListViewController {
    func imagesListObserve() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                if oldCount < newCount {
                    let indexPaths = (oldCount..<newCount).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    tableView.insertRows(at: indexPaths, with: .automatic)
                } else {
                    let indexPaths = (newCount..<oldCount).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    tableView.deleteRows(at: indexPaths, with: .automatic)
                }
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: ImageListCellDelegate {
    func imagesListDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlokingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLike(self.photos[indexPath.row].isLiked)
                UIBlokingProgressHUD.dismiss()
            case .failure:
                UIBlokingProgressHUD.dismiss()
            }
        }
    }
}
