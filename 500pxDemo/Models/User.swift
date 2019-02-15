//
//  File.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-12.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct User: Decodable {

    let id: Int
    let firstName: String
    let lastName: String?
    let fullName: String
    let userPicURLString: String?
    let coverURLString: String?
    let avatars: Avatars
    
    enum CodingKeys: String, CodingKey {
        case id
        case avatars
        case firstName = "firstname"
        case lastName = "lastname"
        case fullName = "fullname"
        case userPicURLString = "userpic_url"
        case coverURLString = "cover_url"
    }
}
