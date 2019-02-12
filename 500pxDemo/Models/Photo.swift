//
//  Photos.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct Photo{
    
    let name: String
    let image: [Image]
    
	
    public init(image: [Image], name: String = "") {
        self.image = image
        self.name = name
	}
}
