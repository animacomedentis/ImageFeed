import UIKit
import Kingfisher

final class ProfileViewController:UIViewController {
    
    
    private let alertPresenter = AlertPresenter()
    private let profileService = ProfileService.shared
    private var storage = OAuth2TokenStorage.shared
    private let logoutService = LogoutService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        setupView()
        setupConstraint()
     
        if let stringURL = profileImageService.avatarURL {
            guard let url = URL(string: stringURL) else { return }
            updateAvatar(url: url)
        }
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else { return }
            self.updateAvatar(notification: notification)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let profile = profileService.profile
        else {
            assertionFailure("no saved profile")
            return }
        updateViewContent(profile: profile)
    }
    //MARK: - view
    private var avatarImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "avatar")
        image.layer.cornerRadius = 35
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private func updateAvatar(notification: Notification)  {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageUrl = userInfo["URL"] as? String,
            let url = URL(string: profileImageUrl)
        else { return }
        
        updateAvatar(url: url)
    }
    
    private func updateAvatar(url: URL) {
        avatarImage.kf.indicatorType = .activity
        avatarImage.kf.setImage(with: url)
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImage.kf.setImage(with: url, options: [.processor(processor)])
    }

    
    private var fullName: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var userName: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var bio: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var logoutButton: UIButton = {

        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.tintColor = .ypRed
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc
    private func didTapLogoutButton(){
        self.logoutAlert()
    }
   
    private func logoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены что хотите выйти?",
                                      preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        alert.addAction(UIAlertAction(title: "Да", style: .default){ action in
            self.logoutService.logout()
            guard let window = UIApplication.shared.windows.first else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main),
                vc = storyboard.instantiateViewController(identifier: "SplashViewController")
            
            window.rootViewController = vc
        })
        present(alert, animated: true)
    }
    //MARK: -setup View + Constraints
    private func setupView() {
        view.addSubview(avatarImage)
        view.addSubview(fullName)
        view.addSubview(userName)
        view.addSubview(bio)
        view.addSubview(logoutButton)
    }
    
    private func updateViewContent (profile: Profile) {
        fullName.text = profile.name
        userName.text = profile.loginName
        bio.text = profile.bio
    }
    
    private func setupConstraint() {
        let avatarImageConstraints = [
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ]
        let fullNameConstraints = [
            fullName.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            fullName.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8)
        ]
        let userNameConstraints = [
            userName.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            userName.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 8)
        ]
        let bioConstraints = [
            bio.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            bio.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8)
        ]
        let logoutButtonConstraints = [
            logoutButton.widthAnchor.constraint(equalToConstant: 40),
            logoutButton.heightAnchor.constraint(equalToConstant: 40),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(avatarImageConstraints
                                    + fullNameConstraints
                                    + userNameConstraints
                                    + bioConstraints
                                    + logoutButtonConstraints)
    }
}
