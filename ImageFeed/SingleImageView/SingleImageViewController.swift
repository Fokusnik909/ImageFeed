//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 12.03.2024.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    private var image = UIImage()
    var fullImageURL: URL?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.minimumZoomScale = 0.1
        self.scrollView.maximumZoomScale = 2.5
        setImage()
    }
    

    //MARK: - Methods
    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }

    @IBAction private func didTapShareButton() {
        shareImage(image)
    }
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: image)
            case .failure:
                showAlert()
            }
        }
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

    private func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    private func centerImage() {
        let boundsSize = scrollView.bounds.size
        var frameToCenter = imageView.frame
    
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
    
    private func showAlert() {
        let alertController = AlertModals.createOkCancelAlert(
            title: "Что-то пошло не так. Попробовать ещё раз?",
            message: nil, okButton: "Повторить",
            cancelButton: "Не надо") { [weak self] in
                self?.setImage()
            } cancelHandler:  { [weak self] in
                self?.dismiss(animated: true)
            }
        present(alertController, animated: true)
    }

}

//MARK: - Extension
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerImage()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
}

extension SingleImageViewController {
    private func shareImage(_ image: UIImage) {
        guard let fileURL = generateTempFileURL(forImage: image) else { return }
        
        if let activityViewController = generateActivityViewController(forFileURL: fileURL) {
            present(activityViewController, animated: true, completion: nil)
        }
    }

    private func generateTempFileURL(forImage image: UIImage) -> URL? {
        let fileManager = FileManager.default
        let tempDirectoryURL = fileManager.temporaryDirectory
        let fileURL = tempDirectoryURL.appendingPathComponent("image.jpg")
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            do {
                try imageData.write(to: fileURL)
                return fileURL
            } catch {
                print("Failed to write image data to file: \(error)")
                return nil
            }
        } else {
            print("Failed to convert image to data")
            return nil
        }
    }

    private func generateActivityViewController(forFileURL fileURL: URL) -> UIActivityViewController? {
        let activityItems = [fileURL]
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
}
