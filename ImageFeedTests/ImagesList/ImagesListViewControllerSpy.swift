//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Nataliya MASSOL on 09/01/2024.
//

@testable import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    
    var updateTableViewAnimatedCalled = false
    var updateLikeStatusCalled = false
    var getCurrentViewControllerCalled = false
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
    }
    
    func updateLikeStatus(at index: Int, isLiked: Bool) {
        updateLikeStatusCalled = true
    }
    
    func getCurrentViewController() -> UIViewController? {
        getCurrentViewControllerCalled = true
              return nil
    }
}
