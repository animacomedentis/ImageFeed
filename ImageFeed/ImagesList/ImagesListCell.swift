//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Максим Петров on 06.12.2023.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    static let reuseIdentifier = "ImagesListCell"
    
}
