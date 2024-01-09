//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Nataliya MASSOL on 08/01/2024.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    var viewController: ProfileViewController!
    var presenterSpy: ProfilePresenterSpy!
    
    override func setUp() {
            super.setUp()
        viewController = ProfileViewController()
            presenterSpy = ProfilePresenterSpy()
            viewController.configure(presenterSpy)
            
            viewController.loadViewIfNeeded()
        }
    override func tearDown() {
            viewController = nil
            presenterSpy = nil
            super.tearDown()
        }
    
    func testViewControllerInitializesCorrectly() {
            XCTAssertNotNil(viewController.presenter)
        }
    
    func testPresenterViewDidLoadCalled() {
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testUpdateProfileDetailsUpdatesUI() {
            // given
            let name = "Test Name"
            let loginName = "Test Login"
            let bio = "Test Bio"
            
            // when
            viewController.updateProfileDetails(name: name, loginName: loginName, bio: bio)
            
            // then
            XCTAssertEqual(viewController.nameLabel.text, name)
            XCTAssertEqual(viewController.loginNameLabel.text, loginName)
            XCTAssertEqual(viewController.descriptionLabel.text, bio)
        }
    func testUpdateAvatarUpdatesUI() {
        // given
        let viewControllerSpy = ProfileViewControllerSpy()
        let url = URL(string: "https://example.com/avatar.jpg")!

        // when
        viewControllerSpy.updateAvatar(with: url)
        
        // then
        XCTAssertEqual(viewControllerSpy.lastAvatarUrl, url)
    }
    
    func testDidTapButtonShowsLogoutAlert() {
          //given
        let mockAlertPresenter = AlertPresenterMock()
        viewController.alertPresenter = mockAlertPresenter
        
        // when
            viewController.didTapButton()
            
            // then
            XCTAssertTrue(mockAlertPresenter.showLogoutAlertCalled)
        }
}
