//
//  Avatar.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-12.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct Avatars: Decodable {
    
    let tinyURLString: [String: String]
    let smallURLString: [String: String]
    let largeURLString: [String: String]
    let defaultURLString: [String: String]
    
    enum CodingKeys: String, CodingKey {
        
        case tinyURLString = "tiny"
        case smallURLString = "small"
        case largeURLString = "large"
        case defaultURLString = "default"
    }
}
