//
//  Token.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 9/28/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import Foundation

final class Token: Decodable {
    var access_token: String?
    var token_type: String?
    var refresh_token: String?
    var expires_in: Int64?
    var scope: String?
    var id: Int64?
    var roles: [String]?
    var jti: String?
}
