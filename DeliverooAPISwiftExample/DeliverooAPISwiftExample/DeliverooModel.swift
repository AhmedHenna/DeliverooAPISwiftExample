//
//  Model.swift
//  DeliverooAPISwiftExample
//
//  Created by Ahmed Henna on 10/6/23.
//

import Foundation

struct DeliverooApiResponse : Codable{
    var access_token: String
    var token_type: String
    var expires_in: Int
    
    
}
