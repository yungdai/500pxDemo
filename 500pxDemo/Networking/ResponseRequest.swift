//
//  ResponseRequest.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-11.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

typealias Payload = [[String: Any]]

struct ResponseRequest {

	var path: String {
		// TODO: Need to figure out the page for the response
		return ""
	}
	
	let parameters: Parameters
	
	private init(parameters: Parameters) {
		self.parameters = parameters
	}
}

extension ResponseRequest {
	
	static func from(site: String)  -> ResponseRequest {
		
		// TODO: Figure out the params to add more later
		let defaultParams = ["order": "desc"]
		
		let params = ["site": "\(site)"].merging(defaultParams, uniquingKeysWith: +)
		
		return ResponseRequest(parameters: params)
	}
}
