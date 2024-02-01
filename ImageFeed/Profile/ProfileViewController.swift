import UIKit

final class ProfileViewController:UIViewController {
    override func viewDidLoad() {
        profiveView()
    }
    
    private func profiveView(){
        let avatarImage = UIImage(named: "avatar")
        let avatar = UIImageView(image: avatarImage)
        
        let nameAndSurname = UILabel()
        nameAndSurname.text = ("Екатерина Новикова")
        nameAndSurname.textColor = .ypWhite
        nameAndSurname.font = UIFont.boldSystemFont(ofSize: 23)
        
        let userName = UILabel()
        userName.text = "@ekaterina_nov"
        userName.textColor = .ypWhiteAlpha50
        
        let userMassage = UILabel()
        userMassage.text = "Hello, world!"
        userMassage.textColor = .ypWhite
        
        let logoutButtonImage = UIImage(named: "logout_button")
        let logoutButton = UIButton.systemButton(with: logoutButtonImage!, target: self, action: #selector(Self.didTapLogoutButton))
        logoutButton.tintColor = .ypRed
        
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatar)
        nameAndSurname.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameAndSurname)
        userName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userName)
        userMassage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userMassage)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        //MARK: constraint
        NSLayoutConstraint.activate([
            //imageView
            avatar.widthAnchor.constraint(equalToConstant: 70),
            avatar.heightAnchor.constraint(equalToConstant: 70),
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            //nameAndSurname
            nameAndSurname.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            nameAndSurname.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8),
            //userName
            userName.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            userName.topAnchor.constraint(equalTo: nameAndSurname.bottomAnchor, constant: 8),
            //userMassage
            userMassage.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            userMassage.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
            //logoutButton
            logoutButton.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    //функционал кнопки выхода из профиля
    @objc
    private func didTapLogoutButton(){
        
    }
}
