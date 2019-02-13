//
//  Avatar.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-12.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct Avatars {
    
    let tiny: URL?
    let small: URL?
    let large: URL?
    let defaultURL: URL?
    
    init(tiny: URL?, small: URL?, large: URL?, defaultURL: URL?) {
        
        self.tiny = tiny
        self.small = small
        self.large = large
        self.defaultURL = defaultURL
    }
}
