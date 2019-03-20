//
//  PhotoDetailsViewController.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-16.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import UIKit

final class PhotoDetailsViewController: UIViewController {
    
    let photosDetailsManager = PhotoDetailsManager.shared

    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func gripTapped(_ sender: Any) {
        
        photosDetailsManager.dismissPhotoDetailsVC()

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
