import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? {get set}
    func updateProfileDetails(profile: Profile)
    func showLogoutAlert()
    func updateAvatar()
}

final class ProfileViewController:UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    private let alertPresenter = AlertPresenter()
    private var storage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        setupView()
        setupConstraint()
        presenter?.viewDidLoad()
        updateAvatar()
    }
    func configure(_ presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    //MARK: - viewContent
    
    private var avatarImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "avatar")
        image.layer.cornerRadius = 35
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        avatarImage.kf.setImage(with: url,
                                     placeholder: UIImage(named: "placeholder"),
                                     options: [.processor(processor)
                                              ]) { result in
            switch result{
            case .success(let value):
                print("Photo: \(value.image)")
                print("Photo cache type: \(value.cacheType)")
                print("Photo source: \(value.source)")
                
            case .failure(let error):
                print("[ProfileViewController]: Error while loading profileImage \(error.localizedDescription)")
            }
        }
        
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
        button.accessibilityIdentifier = "logoutButton"
        return button
    }()
    
    @objc
    func didTapLogoutButton(){
        presenter?.tapLogoutButton()
    }
   
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены что хотите выйти?",
                                      preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        alert.addAction(UIAlertAction(title: "Да", style: .default){ action in
            LogoutService.shared.logout()
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
    
    func updateProfileDetails(profile: Profile) {
        fullName.text = profile.name
        userName.text = profile.loginName
        bio.text = profile.bio
    }
    
    func cleanProfileData() {
        fullName.text = nil
        userName.text = nil
        bio.text = nil
        avatarImage.image = nil
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

