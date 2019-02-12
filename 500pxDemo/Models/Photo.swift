//
//  Photos.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct Photo{
    
	let imageURL: [URL]?
    let name: String
	
    public init(imageURL: [URL]?, name: String = "") {
		self.imageURL = imageURL
        self.name = name
	}
}
