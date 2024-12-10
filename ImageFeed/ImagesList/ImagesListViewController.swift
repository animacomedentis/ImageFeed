import UIKit
import Kingfisher

class ImagesListViewController: UIViewController, ImageListCellDelegate {
   
    @IBOutlet private var tableView: UITableView!
    private let imageListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotoPage()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableView()
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue")
                return
            }
            if let url = photos[indexPath.row].largeImageURL,
               let imageUrl = URL(string: url) {
                viewController.imageURL = imageUrl
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private func loadPhotoPage() {
        imageListService.fetchPhotosNextPage{ _ in }
    }
    
    private func updateTableView() {
        if photos.count == imageListService.photos.count { return }
        tableView.performBatchUpdates {
            let indexPath = (photos.count..<imageListService.photos.count).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPath, with: .automatic)
            photos = imageListService.photos
        }
    }
    
    
}//ImagesListViewController

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        
        let photoURL = photos[indexPath.row]
        guard let url = photoURL.thumbImageURL,
              let photoUrl = URL(string: url)
        else {
            return
        }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.contentMode = .center
        cell.cellImage.kf.setImage(with: photoUrl,
                                   placeholder: UIImage(named: "photos_placeholder")
        ) { [weak self] _ in
            guard self != nil else { return }
            cell.cellImage.contentMode = .scaleToFill
        }
        
        if let date = photoURL.createdAt{
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        
        cell.setIsLiked(photoURL.isLiked)
    }
}

extension ImagesListViewController {
    func imagesListCellDidLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        //UIBlockingProgressHUD.show()
        imageListService.changeLike(photoID: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
          //  UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                self.photos = self.imageListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
            case .failure:
                self.showLikeErrorAlert()
            }
        }
    }
    
    private func showLikeErrorAlert(){
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Не удалось поставить лайк",
                                      preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK",
                                   style: .default
        )
        
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell
        else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        configCell(for: cell, with: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1) == photos.count {
            loadPhotoPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}


