//
//  HTTPResult.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

enum Result<T, E: Error> {
    
    case success(T)
    case error(E)
}
