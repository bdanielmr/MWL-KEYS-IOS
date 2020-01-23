//
//  KeyRequest.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 10/4/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import Foundation

struct KeyRequest : Codable {
    var vehicleRegistrationID: Int64;
    var numberOfKeys: Int;
    var deliveryMethod: String;
    var address: Address?
}

struct KeyOrder: Codable {
    var deliveryMethod: String;
    var numberOfKeys: Int
    var vehicleRegistration: Registration
}

enum ScanType {
    case scanVIN;
    case scanLabel;
}
