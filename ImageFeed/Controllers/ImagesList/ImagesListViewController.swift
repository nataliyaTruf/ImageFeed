//
//  ViewController.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 27/07/2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private(set) var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var isInitialDataLoaded = false
    private var imagesListServiceObserver: NSObjectProtocol?
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isInitialDataLoaded {
             loadInitialPhotos() }
        imagesListObserve()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //    private lazy var dateFormatter: DateFormatter = {
    //        let formatter = DateFormatter()
    //        formatter.dateStyle = .long
    //        formatter.timeStyle = .none
    //        return formatter
    //    }()
    
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
        cell.dateLabel.text = DateFormatterUtil.dateFormatter.string(from: Date()).replacingOccurrences(of: "г.", with: "")
        
        let isLiked = indexPath.row % 2 == 1
        let likeImage = isLiked ? UIImage(named: "LikeButtonOn") : UIImage(named: "LikeButtonOff")
        cell.likeButton.setImage(likeImage, for: .normal)
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
    func loadInitialPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    func imagesListObserve() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
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

