//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Артур  Арсланов on 12.03.2024.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
}
