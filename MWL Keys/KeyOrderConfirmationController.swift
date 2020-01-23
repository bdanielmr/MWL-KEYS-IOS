//
//  KeyOrderViewConfirmationController.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 10/6/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import UIKit

class KeyOrderConfirmationController: UIViewController {
    
    @IBOutlet weak var confirmationNumberLabel: UILabel!
    @IBOutlet weak var vehicleNumberLabel: UILabel!
    @IBOutlet weak var numberOfKeysLabel: UILabel!
    @IBOutlet weak var deliveryMethodLabel: UILabel!
    
    var keyOrder: KeyOrder!
    var confirmShipping: Bool!
    
    override func viewDidLoad() {
           super.viewDidLoad();
        setValues();
    }
    
    func setValues() {
        self.vehicleNumberLabel.text = String(keyOrder.vehicleRegistration.customerVehicleID);
        self.confirmationNumberLabel.text = "Confirmation # 12389";
        self.numberOfKeysLabel.text = String(keyOrder.numberOfKeys);
        
    }
}
