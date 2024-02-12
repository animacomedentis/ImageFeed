import UIKit

final class AuthViewController: UIViewController{
    override func viewDidLoad() {
        showAuthView()
    }
    
    private func showAuthView(){
        let authViewLogoImage = UIImage(named: "auth_screen_logo")
        let authViewLogo = UIImageView(image: authViewLogoImage)
        
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.backgroundColor = .ypWhite
        loginButton.layer.cornerRadius = 16
        loginButton.layer.masksToBounds = true
        loginButton.tintColor = .ypBlack
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        //MARK: add subView and off mask
        authViewLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authViewLogo)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        //MARK: constraint
        NSLayoutConstraint.activate([
            //authViewLogo
            authViewLogo.widthAnchor.constraint(equalToConstant: 60),
            authViewLogo.heightAnchor.constraint(equalToConstant: 60),
            authViewLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authViewLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            //authViewButton
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    @objc
    private func didTapLoginButton(){
        
    }
}
