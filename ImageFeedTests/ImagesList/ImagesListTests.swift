//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Nataliya MASSOL on 09/01/2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    var viewController: ImagesListViewController!
    var presenterSpy: ImagesListViewPresenterSpy!
    var viewSpy: ImagesListViewControllerSpy!
    var serviceMock: ImagesListServiceMock!
    var presenter: ImagesListPresenter!
    var navigationServiceSpy: NavigationServiceSpy!
    var imagesListService: ImagesListServiceProtocol!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        
        viewSpy = ImagesListViewControllerSpy()
        serviceMock = ImagesListServiceMock()
        ImagesListService.shared = serviceMock
        presenter = ImagesListPresenter()
        presenter.view = viewSpy
        presenterSpy = ImagesListViewPresenterSpy()
        navigationServiceSpy = NavigationServiceSpy()
        NavigationService.shared = navigationServiceSpy
        imagesListService = ImagesListService.shared
        imagesListService = serviceMock
        viewController.presenter = presenterSpy
    }
    
    override func tearDown() {
        viewController = nil
        presenterSpy = nil
        viewSpy = nil
        serviceMock = nil
        presenter = nil
        imagesListService = ImagesListService.shared
        super.tearDown()
    }
    func testViewControllerConfiguration() {
        //when
        _ = viewController.view
        viewController.configurePresenter(presenterSpy)
        
        //then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testPresenterViewDidLoad() {
        //when
        presenter.viewDidLoad()
        
        XCTAssertTrue(serviceMock.fetchPhotosNextPageCalled)
    }
    
    func testPresenterDidTapLikeButton() {
        // given
        let photo1 = Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: Date(), welcomeDescription: "Description 1", thumbImageURL: "url1", largeImageURL: "url2", smallImageURL: "url3", isLiked: false)
        let photo2 = Photo(id: "2", size: CGSize(width: 100, height: 100), createdAt: Date(), welcomeDescription: "Description 2", thumbImageURL: "url4", largeImageURL: "url5", smallImageURL: "url6", isLiked: true)
        
        serviceMock.photos = [photo1, photo2]
        presenter.photos = serviceMock.photos
        
        // when
        presenter.didTapLikeButton(at: 0)
        
        // then
        XCTAssertTrue(serviceMock.changeLikeCalled)
    }
    
    func testUpdateLikeStatus() {
        // given
        let photo1 = Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: Date(), welcomeDescription: "Description 1", thumbImageURL: "url1", largeImageURL: "url2", smallImageURL: "url3", isLiked: false)
        let photo2 = Photo(id: "2", size: CGSize(width: 100, height: 100), createdAt: Date(), welcomeDescription: "Description 2", thumbImageURL: "url4", largeImageURL: "url5", smallImageURL: "url6", isLiked: true)
        
        serviceMock.photos = [photo1, photo2]
        presenter.photos = serviceMock.photos
        
        // when
        presenter.didTapLikeButton(at: 0)
        
        //then
        XCTAssertTrue(viewSpy.updateLikeStatusCalled)
    }
    
    func testWillDisplayRow() {
        //given
        let lastIndexPath = IndexPath(row: serviceMock.photos.count - 1, section: 0)
        
        //when
        presenter.willDisplayRow(at: lastIndexPath)
        
        //then
        XCTAssertTrue(serviceMock.fetchPhotosNextPageCalled)
    }
    
    func testDidSelectRow() {
        //given
        let testPhoto = Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: Date(), welcomeDescription: "Test Description", thumbImageURL: "test_url1", largeImageURL: "test_url2", smallImageURL: "test_url3", isLiked: false)
        serviceMock.photos = [testPhoto]
        
        presenter.photos = serviceMock.photos
        let indexPath = IndexPath(row: 0, section: 0)
        
        //when
        presenter.didSelectRow(at: indexPath)
        navigationServiceSpy.presentSingleImage(from: nil, withPhoto: testPhoto)
        //then
        XCTAssertTrue(navigationServiceSpy.presentSingleImageCalled)
    }
}
