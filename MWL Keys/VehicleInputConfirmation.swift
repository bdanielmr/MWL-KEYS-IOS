//
//  VehicleInputConfirmation.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 10/5/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import UIKit

class VehicleInputConfirmationController: UIViewController {
    
    @IBOutlet weak var notesTextArea: UITextView!
    @IBOutlet weak var addressTextArea: UITextView!
    @IBOutlet weak var keyCodeLabel: UILabel!
    @IBOutlet weak var customerIDLabel: UILabel!
    var registration: Registration!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        updateFields()
    }
    
    func updateFields() -> Void {
        self.customerIDLabel.text =
            "Confirmation for Vehicle # " + registration.customerVehicleID;
        self.keyCodeLabel.text = registration.keyCode;
        setAddress();
        setNotes()
    }
    
    func setAddress() -> Void {
        self.addressTextArea.text = registration.address.formattedAddress();
    }
    
    func setNotes() -> Void {
        if let notes = registration.notes {
            self.notesTextArea.text = notes;
        } else {
            
        }
    }
}
