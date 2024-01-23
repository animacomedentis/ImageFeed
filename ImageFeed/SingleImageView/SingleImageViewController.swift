import UIKit

class SingleImageViewController:UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var image:UIImage!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
