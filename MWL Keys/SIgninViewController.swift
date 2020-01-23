//
//  SIgninViewController.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 9/28/19.
//  Copyright © 2019 BitByBit Software Inc. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad();
        configureTextFields();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func configureTextFields() {
        emailAddressTextField.delegate = self;
        passwordTextField.delegate = self;
        errorLabel.isHidden = true;
    }
    
    @IBAction func SignInButtonTapped(_ sender: Any) {
        if let username = emailAddressTextField.text, let password = passwordTextField.text {
            if !validateInput(username,password: password) {
                print("not valid");
                return;
            }
            let apiRequest = APIRequest();
                       apiRequest.getToken(username, password: password, completion: { result in
                           switch result {
                           case .success(let token):
                            print(token.access_token as Any);
                            self.storeAccessToken(token);
                            self.navigateToController(token.roles!);
                           case .failure(let error):
                            print(error);
                            self.setErrorMessage(error.message!);
                           }
                       });
        } else {
            print("no username or password entered");
        }
    }
    
    func validateInput(_ username: String, password: String) -> Bool {
            let response = Validation.shared.validate(values: (ValidationType.username, username),
                                                      (ValidationType.password, password));
            switch response {
            case .success:
                return true;
            case .failure(_, let message):
                setErrorMessage(message.localized());
                return false;
            }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async(execute: {
            self.errorLabel.text = message;
            self.errorLabel.isHidden = false;
        });
    }
    
    func navigateToController(_ roles: [String]) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main);
        do {
            if( roles.contains("ADMIN")) {
            // Updates your UIs on main queue
                DispatchQueue.main.async(execute: {
                    guard let mainNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "AdminNavigationController") as?
                       AdminNavigationController else {
                           return;
                    };
                   
                    self.present(mainNavigationVC, animated: true, completion: nil);
                });
            } else {
                DispatchQueue.main.async(execute: {
                    guard let mainNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "CustomerNavigationController") as?
                       CustomerNavigationController else {
                           return;
                    };
                   
                    self.present(mainNavigationVC, animated: true, completion: nil);
                });
            };
        };
    }
    
    let tokenIdentifier = "TokenIdentifier"
    func storeAccessToken(_ token: Token) {
        KeychainWrapper.standard.set(token.access_token!, forKey: tokenIdentifier);
    }

    func checkUserLogin() {
        let token: String? = KeychainWrapper.standard.string(forKey: tokenIdentifier);
        if token != nil {
            print("User is Login");
        }
        else {
            print("User need to login");
        };
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}
