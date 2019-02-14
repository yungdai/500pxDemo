//
//  MainAppViewController.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-14.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import UIKit


let showcaseNavVC = "showcaseNavVC"
let showcaseVCSegue = "showcaseVCSegue"

class MainAppViewController: UIViewController {
    
    weak var showcaseNavVC: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // init the showcaseNavVC Container
        if segue.identifier == showcaseVCSegue {
            
            guard let showcaseNavVC = segue.destination as? UINavigationController else { return }
            
            self.showcaseNavVC = showcaseNavVC
        }
    }
}
