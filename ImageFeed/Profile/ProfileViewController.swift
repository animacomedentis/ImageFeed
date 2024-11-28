import UIKit
import Kingfisher

final class ProfileViewController:UIViewController {
    
    
    private var alertPresenter = AlertPresenter()
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
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
    private var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "logout_button")!,
            target: ProfileViewController.self,
            action: #selector(Self.didTapLogoutButton))
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    
    //TODO: функционал кнопки выхода из профиля
    @objc
    private func didTapLogoutButton(){
       
   }
    
}
