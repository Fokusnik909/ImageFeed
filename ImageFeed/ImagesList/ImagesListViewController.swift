//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 17.02.2024.
//

import UIKit

public protocol ImageListViewControllerProtocol: AnyObject {
    func updateTableViewAnimated(with indexPaths: [IndexPath])
    func isShowProgressHUD(_ hud: Bool)
}

final class ImagesListViewController: UIViewController, ImageListViewControllerProtocol {
    // MARK: - Private Properties
    @IBOutlet private var tableView: UITableView!
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    var presenter: ImagesListPresenterProtocol?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImagesListPresenter(view: self)
        presenter?.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.removeObserver()
    }
    
    //MARK: - Methods
    func updateTableViewAnimated(with indexPaths: [IndexPath]) {
        tableView.performBatchUpdates({
            tableView.insertRows(at: indexPaths, with: .automatic)
        }, completion: nil)
    }
    
    func isShowProgressHUD(_ hud: Bool){
        if hud {
            UIBlockingProgressHUD.show()
        } else {
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = presenter?.passImage(at: indexPath)
            viewController.fullImageURL = image?.fullImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.imageListCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let cell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        if let photo = presenter?.passImage(at: indexPath) {
            cell.configCell(for: cell, with: indexPath, photo: photo, tableView: tableView)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchNextPageIfNeeded(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = presenter?.passImage(at: indexPath) else {
            return 100
        }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        presenter?.didTapLike(at: indexPath) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let isLiked):
                cell.setIsLiked(isLike: isLiked)
            case .failure(let error):
                let alertController = AlertModals.createOkAlert(
                    title: "Ошибка",
                    message: "Что-то пошло не так, попробуйте снова",
                    okButton: "Ок"
                )
                self.present(alertController, animated: true)
                print(error)
            }
        }
    }
}

