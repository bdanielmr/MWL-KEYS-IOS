//
//  CustomerViewController.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 9/30/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import UIKit

class CustomerDashboardController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func signoutTapped(_ sender: Any) {
        TokenService().removeAccessToken();
        backToLogin();
    }
    
    func backToLogin() {
        
          let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main);
        
        guard let mainNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as?
                    SignInViewController else {
                                 return;
                         }
                         
                  self.present(mainNavigationVC, animated: true, completion: nil)
    }
}
