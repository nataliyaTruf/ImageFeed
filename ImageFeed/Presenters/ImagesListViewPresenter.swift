//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Nataliya TRUFANOVA on 07/01/2024.
//

import Foundation

protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func didSelectRow(at indexPath: IndexPath)
    func willDisplayRow(at indexPath: IndexPath)
    func didTapLikeButton(at index: Int)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService.shared
    private(set) var photos: [Photo] = []
    
    func viewDidLoad() {
        observePhotoListChanges()
        imagesListService.fetchPhotosNextPage()
    }
    
    func observePhotoListChanges() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
    private func updateTableViewAnimated() {
        let oldCount = self.photos.count
        let newPhotos = self.imagesListService.photos
        let newCount = newPhotos.count
        if oldCount != newCount {
            self.photos = newPhotos
            self.view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    func didSelectRow(at indexPath: IndexPath) {
        guard indexPath.row < photos.count,
              let viewController = view?.getCurrentViewController() else { return }
        let photo = photos[indexPath.row]
        
        NavigationService.shared.presentSingleImage(from: viewController, withPhoto: photo)
    }
    
    func willDisplayRow(at indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func didTapLikeButton(at index: Int) {
        guard index < photos.count else { return }
        let photo = photos[index]
        UIBlokingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                let isLiked = self.photos[index].isLiked
                self.view?.updateLikeStatus(at: index, isLiked: isLiked)
                UIBlokingProgressHUD.dismiss()
            case .failure:
                UIBlokingProgressHUD.dismiss()
            }
        }
    }
}
