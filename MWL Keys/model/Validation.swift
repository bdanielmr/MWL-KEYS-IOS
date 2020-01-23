//
//  Validation.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 10/10/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import Foundation

enum Alert {        //for failure and success results
    case success;
    case failure;
    case error;
}
//for success or failure of validation with alert message
enum Valid {
    case success;
    case failure(Alert, AlertMessages);
}
enum ValidationType {
    case username;
    case email;
    case stringWithFirstLetterCaps;
    case phoneNo;
    case alphabeticString;
    case password;
}
enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; // Email
    case password = "^.{5,20}$"; // Password length 6-20
    case username = "^.{4,12}$"; // username
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$"; // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$"; // SandsHell
    case phoneNo = "[0-9]{10,14}"; // PhoneNo 10-14 Digits        //Change RegEx according to your Requirement
}

enum AlertMessages: String {
    case inValidEmail = "Invalid Email";
    case invalidFirstLetterCaps = "First Letter should be capital";
    case inValidPhone = "Invalid Phone";
    case invalidAlphabeticString = "Invalid String";
    case inValidPSW = "Invalid Password";
    case inValidUsername = "Invalid USername";
        
    case emptyPhone = "Empty Phone";
    case emptyEmail = "Empty Email";
    case emptyFirstLetterCaps = "Empty Name";
    case emptyAlphabeticString = "Empty String";
    case emptyPSW = "Empty Password";
    case emptyUsername = "Empty Username";
    
     func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "");
    };
}

class Validation: NSObject {
    
    public static let shared = Validation();
    
    func validate(values: (type: ValidationType, inputValue: String)...) -> Valid {
        for valueToBeChecked in values {
            switch valueToBeChecked.type {
            case .email:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .email, .emptyEmail, .inValidEmail)) {
                    return tempValue;
                };
            case .stringWithFirstLetterCaps:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .alphabeticStringFirstLetterCaps, .emptyFirstLetterCaps, .invalidFirstLetterCaps)) {
                    return tempValue;
                };
            case .phoneNo:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .phoneNo, .emptyPhone, .inValidPhone)) {
                    return tempValue;
                };
            case .alphabeticString:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .alphabeticStringWithSpace, .emptyAlphabeticString, .invalidAlphabeticString)) {
                    return tempValue;
                };
            case .password:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .password, .emptyPSW, .inValidPSW)) {
                    return tempValue;
                };
            case .username:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .username, .emptyUsername, .inValidUsername)) {
                    return tempValue;
                };
            };
        }
        return .success
    }
    
    func isValidString(_ input: (text: String, regex: RegEx, emptyAlert: AlertMessages, invalidAlert: AlertMessages)) -> Valid? {
        if input.text.isEmpty {
            return .failure(.error, input.emptyAlert);
        } else if isValidRegEx(input.text, input.regex) != true {
            return .failure(.error, input.invalidAlert);
        }
        return nil;
    }
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue);
        let result = stringTest.evaluate(with: testStr);
        return result;
    }
}
