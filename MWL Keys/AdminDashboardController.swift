//
//  ViewController.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 9/26/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import UIKit

class AdminDashboardController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? ScannerViewController
        {
            print("segue name is " + segue.identifier!);
            let scanType: ScanType;
            if(segue.identifier! == "ScanVIN") {
                scanType = .scanVIN;
            } else {
                scanType = .scanLabel;
            }
            vc.scanType = scanType;
        }
    }

}

