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
