//
//  Photos.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    
    let name: String
    let images: [Image]
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case name, images, user
    }
}
