//
//  NetworkServiceTest.swift
//  MWL KeysTests
//
//  Created by Marcus Lowe on 9/29/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import XCTest
@testable import MWL_Keys

class NetworkServiceTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetToken() {
        let uname = "bob";
        let pword = "89823";
        let sharedService = APIRequest(endpoint: "token")
        sharedService.getToken(uname, password: pword, completion: { result in
            switch result {
            case .success(let token):
                print(token);
            case .failure(let error):
                print(error)
            }
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
