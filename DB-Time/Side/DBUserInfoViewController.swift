//
//  DBUserInfoViewController.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/4.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit

class DBUserInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
