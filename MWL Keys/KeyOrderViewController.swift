//
//  KeyOrderViewController.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 10/2/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import UIKit

class KeyOrderViewController: UIViewController, UIPickerViewDelegate,
UIPickerViewDataSource {
    
    @IBOutlet weak var deliveryTurnaround: UIPickerView!;
    @IBOutlet weak var numberOfKeys: UITextField!;
    @IBOutlet weak var addressTextView: UITextView!;
    
    @IBOutlet weak var textDelivery: UITextField!
    @IBOutlet weak var addresTextViewLine1: UITextView!
    @IBOutlet weak var addresTextViewLine2: UITextView!
    @IBOutlet weak var addresTextViewCity: UITextView!
    @IBOutlet weak var addresTextViewState: UITextView!
    
    @IBOutlet weak var addressTextViewCodeArea: UITextView!
    @IBOutlet weak var vehicleIDLabel: UILabel!;
    
    @IBOutlet weak var addresDateView: UIView!
    
    
    @IBOutlet weak var addressDateViewLine2: UIView!
    
    @IBOutlet weak var addresDateViewCity: UIView!
    
    @IBOutlet weak var addresDateViewState: UIView!
    
    @IBOutlet weak var addresDateViewCodeArea: UIView!
    
    private let addresDataViewColor = UIColor(red:210/255, green: 210/255, blue: 210/255, alpha: 1)
    
    // 3 items for the picker.
    var data = ["1 DAY", "2/3 DAY", "OTHER"];

    var registration: Registration!;
    
    override func viewDidLoad() {
        addresDateView.layer.borderColor = addresDataViewColor.cgColor
        addresDateView.layer.borderWidth = 1
        addresDateView.layer.cornerRadius = 3
        addresDateView.clipsToBounds = true
        
        addressDateViewLine2.layer.borderColor
            = addresDataViewColor.cgColor
        addressDateViewLine2.layer.borderWidth = 1
        addressDateViewLine2.layer.cornerRadius = 3
        addressDateViewLine2.clipsToBounds = true
        
        addresDateViewCity.layer.borderColor
            = addresDataViewColor.cgColor
        addresDateViewCity.layer.borderWidth = 1
        addresDateViewCity.layer.cornerRadius = 3
        addresDateViewCity.clipsToBounds = true
        
        addresDateViewState.layer.borderColor
            = addresDataViewColor.cgColor
        addresDateViewState.layer.borderWidth = 1
        addresDateViewState.layer.cornerRadius = 3
        addresDateViewState.clipsToBounds = true
        
        addresDateViewCodeArea.layer.borderColor
            = addresDataViewColor.cgColor
        addresDateViewCodeArea.layer.borderWidth = 1
        addresDateViewCodeArea.layer.cornerRadius = 3
        addresDateViewCodeArea.clipsToBounds = true
        
                
        super.viewDidLoad();
        setFields();
    }
    
    func setFields() {
        self.deliveryTurnaround.delegate = self;
        self.deliveryTurnaround.dataSource = self;
        self.numberOfKeys.delegate = self;
        self.vehicleIDLabel.text = "Vehicle # " +  registration.customerVehicleID;
        self.addressTextView.text = registration.address.formattedAddress();
        
        self.addresTextViewLine1.text = registration.address.dLine1();
        
        self.addresTextViewCity.text = registration.address.dCity();
        
        self.addresTextViewState.text = registration.address.dState();
        
        self.addressTextViewCodeArea.text = registration.address.dArea();
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let numberOfKeys = self.numberOfKeys?.text {
            let keyRequest = KeyRequest(
                vehicleRegistrationID: registration.pk, numberOfKeys: Int(numberOfKeys)!, deliveryMethod: "1 DAY", address: nil);
                KeyOrderAPI().postKeyRequest(keyRequest, completion: { result in
                   switch result {
                   case .success(let keyOrder):
                       self.goToConfirmation(keyOrder);
                   case .failure(let error):
                        print(error);
                    };
                });
        } else {
            print("missing stuff");
        };
    }
    
    func goToConfirmation(_ keyOrder: KeyOrder) {
        DispatchQueue.main.async(execute: {
               if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KeyOrderConfirmationController") as? KeyOrderConfirmationController {
                viewController.keyOrder = keyOrder;
                   if let navigator = self.navigationController {
                    navigator.pushViewController(viewController, animated: true);
                };
            };
        });
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count;
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
               // Return a string from the array for this row.
        self.view.endEditing(true)
        return data[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        self.textDelivery.text = self.data[row]
        self.deliveryTurnaround.isHidden = true

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == self.textDelivery {
            self.deliveryTurnaround.isHidden = false
            //if you dont want the users to se the keyboard type:

            textField.endEditing(true)
        }

    }
    
}


extension KeyOrderViewController: UITextFieldDelegate {

      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder();
          return true;
      }
  }

  extension KeyOrderViewController: UITextViewDelegate {

      func textFieldShouldReturn(_ textView: UITextView) -> Bool {
          textView.resignFirstResponder();
          return true;
      }
}
