//
//  TokenService.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 10/2/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import Foundation


struct TokenService {
    let tokenIdentifier = "TokenIdentifier"
    func storeAccessToken(_ token: Token) -> Void {
        KeychainWrapper.standard.set(token.access_token!, forKey: tokenIdentifier)
    }
    
    func getAccessToken() -> String {
        if let accessToken = KeychainWrapper.standard.string(forKey: tokenIdentifier) {
            return accessToken;
        } else {
            return "";
        }
    }
    
    func removeAccessToken() -> Void {
        KeychainWrapper.standard.removeObject(forKey: tokenIdentifier);
    }
}
