//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 19.02.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}


final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(isLike: Bool) {
        let imageLike = isLike ? "Active" : "No Active"
        likeButton.setImage(UIImage(named: imageLike), for: .normal)
    }
    
    func configCell(for cell: ImagesListCell,
                    with indexPath: IndexPath,
                    photo: Photo,
                    tableView: UITableView) {
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: photo.thumbImageURL,
                                   placeholder: UIImage(named: "placeholderImage")) { _ in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.dateLabel.text = photo.createdAt
        setIsLiked(isLike: photo.isLiked)
    }
                                   
}
