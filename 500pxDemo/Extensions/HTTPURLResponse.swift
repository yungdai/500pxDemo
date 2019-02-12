//
//  HTTPURLResponse.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    
    // return success http status range
    var isSuccessfullStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
