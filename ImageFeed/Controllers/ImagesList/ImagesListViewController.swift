//
//  ViewController.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 27/07/2023.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func updateLikeStatus(at index: Int, isLiked: Bool)
    func getCurrentViewController() -> UIViewController?
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    private let dateFormater = CustomDateFormatters.shared.dateFormatter
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //presenter = ImagesListPresenter()
        //presenter?.view = self
        presenter?.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func getCurrentViewController() -> UIViewController? {
        return self
    }
    
    func configurePresenter(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        if let photo = presenter?.photos[indexPath.row] {
            imageListCell.configure(with: photo, isLiked: photo.isLiked)
        }
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter = presenter,
              indexPath.row < presenter.photos.count else { return 0 }
        let image = presenter.photos[indexPath.row]
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
        presenter?.willDisplayRow(at: indexPath)
    }
}

extension ImagesListViewController {
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
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

extension ImagesListViewController: ImageListCellDelegate {
    func imagesListDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.didTapLikeButton(at: indexPath.row)
    }
    func updateLikeStatus(at index: Int, isLiked: Bool) {
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ImagesListCell {
            cell.setIsLike(isLiked)
        } else {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
}
