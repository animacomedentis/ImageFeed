import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imagesListCellDidLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImageListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imagesListCellDidLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let image = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            self.likeButton.setImage(image, for: .normal)
        }
    }
}

