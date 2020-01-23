//
//  VehicleInputController.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 9/28/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import UIKit

class VehicleInputController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    
    
    @IBOutlet weak var customerVehicleID: UITextField!
    @IBOutlet weak var VINLabel: UILabel!
    @IBOutlet weak var keyCode: UITextField!
    @IBOutlet weak var addressLine1: UITextField!
    @IBOutlet weak var addressLine2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var dropdown: UIPickerView!
    @IBOutlet weak var areaCode: UITextField!
    @IBOutlet weak var notes: UITextView!
    
    var scannedVin: String!;
    
    var registration: Registration?;
    
    var list = ["AL","AK","AZ","AR","AA","AE","AP","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY",""]
    
    private let delineadoColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.VINLabel.text = scannedVin;
        self.VINLabel.textAlignment = .center;
        notes.layer.borderColor = delineadoColor.cgColor
        notes.layer.borderWidth = 1
        notes.layer.cornerRadius = 3
        notes.clipsToBounds = true
        
        checkForExistingRegistration();
        initTextFields();
        
    }
    //functions of dropbox list of state
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int {
        
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow
        row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return list[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow
        row: Int, inComponent component: Int) {
        
        self.state.text = self.list[row]
        self.dropdown.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.state {
            self.dropdown.isHidden = false
            
            textField.endEditing(true)
        }
    }
    
    func checkForExistingRegistration() -> Void {
        APIRequest().getRegistrationByVIN(scannedVin, completion: { result in
             DispatchQueue.main.async(execute: {
                switch result {
                case .success(let registration):
                    self.registration = registration;
                    self.setFieldValuesFromRegistration();
                default:
                    print("nothing to see");
                };
             });
        });
    }
    
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning();
    }
    
    func initTextFields() {
        customerVehicleID.delegate = self;
        keyCode.delegate = self;
        addressLine1.delegate = self;
        addressLine2.delegate = self;
        city.delegate = self;
        state.delegate = self;
        areaCode.delegate = self;
        notes.delegate = self;
    }
    
    func setFieldValuesFromRegistration() {
        self.customerVehicleID.text = registration!.customerVehicleID;
        self.keyCode.text = registration!.keyCode;
        self.addressLine1.text = registration!.address.line1;
        if let line2 = registration!.address.line2 {
            self.addressLine2.text = line2;
        }
        self.city.text = registration!.address.city;
        self.state.text = registration!.address.stateOrProvince;
        self.areaCode.text = registration!.address.areaCode;
        self.notes.text = registration!.notes;
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let apiRequest = APIRequest();
        if let VIN = VINLabel?.text, let customerVehicleID = self.customerVehicleID?.text,
            let keyCode = self.keyCode?.text,
            let addressLine1 = self.addressLine1?.text, let city = self.city?.text,
            let state = self.state?.text, let areaCode = self.areaCode?.text {
        let registration = VehicleRegistration();
            registration.VIN = VIN;
            registration.customerVehicleID = customerVehicleID;
            registration.addressLine1 = addressLine1;
            registration.city = city;
            registration.state = state;
            registration.areaCode = areaCode;
            registration.keyCode = keyCode;
            if let notes = self.notes?.text {
                registration.notes = notes;
            }
        apiRequest.postVehicleRegistration(registration, completion: { result in
            switch result {
            case .success(let registration):
                self.goToConfirmation(registration);
            case .failure(let error):
                    print(error);
            };
        });
        } else {
            print("missing stuff");
        };
    }
    
    func goToConfirmation(_ registration: Registration) {
        DispatchQueue.main.async(execute: {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VehicleInputConfirmationController") as? VehicleInputConfirmationController {
                      viewController.registration = registration;
                if let navigator = self.navigationController {
                navigator.pushViewController(viewController, animated: true);
                };
            };
        });
    }
    
}

extension VehicleInputController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

extension VehicleInputController: UITextViewDelegate {

    func textFieldShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder();
        return true;
    }
}
