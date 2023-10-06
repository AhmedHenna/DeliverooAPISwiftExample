//
//  Helpers.swift
//  DeliverooAPISwiftExample
//
//  Created by Ahmed Henna on 10/7/23.
//

import Foundation

func concatenateAndEncodeBase64(string1: String, string2: String) -> String? {
    let concatenatedString = "\(string1):\(string2)"
    
    if let data = concatenatedString.data(using: .utf8) {
        return data.base64EncodedString()
    }
    
    return nil
}

// TODO: a method that should look through the Restaurant Model to find our resturant and return lat and lon

// TODO: Add methods from previous project to caclualte which delievry system to go to, accept/deny, and dispay orders
