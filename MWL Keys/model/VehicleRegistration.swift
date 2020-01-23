//
//  VehicleRegistration.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 10/2/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import Foundation

final class VehicleRegistration: Codable {
    var pk: Int64?
    var VIN: String?;
    var customerVehicleID: String?;
    var fleetOwnerID: Int64? = 1;
    var keyCode: String?;
    var addressLine1: String?;
    var addressLine2: String?;
    var city: String?;
    var state: String?;
    var areaCode: String?;
    var notes: String?;
}

struct Vehicle: Codable {
    var pk: Int64;
    var vin: VIN;
}

struct VIN: Codable {
    var pk: Int64;
    var value: String;
}

struct Address: Codable {
    var pk: Int64;
    var line1: String;
    var line2: String?;
    var city: String;
    var stateOrProvince: String;
    var areaCode: String;
    var createdAt: String?;
    var updatedAt: String?;
    
    func dLine1 () -> String{
        let dircLin21 = line1
        
        return dircLin21;
    }
    

    func dCity () -> String{
        let dircCity = city
        return dircCity;
    }
    
    
    func dState() -> String {
        
        let dircState = stateOrProvince
        return dircState;
    }
    
    func dArea () -> String {
        let dircArea = areaCode
        return dircArea;
    }
    
    
    func formattedAddress() -> String {
            var addressDisplay = line1 + "\n";
                addressDisplay = addressDisplay + city + ", "
                + stateOrProvince + " " + areaCode;
        return addressDisplay;
    }
    
    
}

struct FleetOwner: Codable {
    var pk: Int64;
    var name: String;
    var address: Address;
    var createdAt: String?;
    var updatedAt: String?;
}

struct Label: Codable {
    var pk: Int64;
    var id: String;
}

struct Key: Codable {
    var pk: Int64;
}

struct Registration: Codable {
    var pk: Int64;
    var vehicle: Vehicle;
    var keys: [Key]?;
    var label: Label;
    var keyCode: String;
    var notes: String?;
    var fleetOwner: FleetOwner;
    var address: Address;
    var customerVehicleID: String;
    var createdAt: String?;
    var updatedAt: String?;
}
