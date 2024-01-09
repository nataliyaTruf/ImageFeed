//
//  FileImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Nataliya MASSOL on 09/01/2024.
//

@testable import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListPresenterProtocol {
    var imagesListService: ImageFeed.ImagesListServiceProtocol = ImagesListService.shared
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var viewDidLoadCalled = false
        var didSelectRowCalled = false
        var willDisplayRowCalled = false
        var didTapLikeButtonCalled = false
    
    var photos: [ImageFeed.Photo] = []
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        didSelectRowCalled = true
    }
    
    func willDisplayRow(at indexPath: IndexPath) {
        willDisplayRowCalled = true
    }
    
    func didTapLikeButton(at index: Int) {
        didTapLikeButtonCalled = true
    }
}
