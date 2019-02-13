//
//  File.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-12.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct User {

    let id: Int
    let firstName: String
    let lastName: String
    let fullName: String
    let userPicURL: URL?
    let coverURL: URL?
    let avatars: Avatars?
    
    init(id: Int, firstName: String = "", lastName: String = "", fullName: String = "", userPicURL: URL?, coverURL: URL?, avatars: Avatars?) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.userPicURL = userPicURL
        self.coverURL = coverURL
        self.avatars = avatars
    }
}
