

import UIKit


class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func signInButton(_ sender: UIButton) {
        
            let signin = LoginViewController()
            signin.modalPresentationStyle = .fullScreen
            self.present(signin, animated: true, completion: nil)
    }
    
}
