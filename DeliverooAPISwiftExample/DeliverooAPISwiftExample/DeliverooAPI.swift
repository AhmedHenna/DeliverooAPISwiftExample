//
//  DeliverooAPI.swift
//  DeliverooAPISwiftExample
//
//  Created by Ahmed Henna on 10/6/23.
//

import Foundation


func requestDeliverooApiToken(clientID: String, clientSecret: String, completion: @escaping (Result<DeliverooApiResponse, Error>) -> Void) {
    let tokenURL = URL(string: "https://auth.developers.deliveroo.com/oauth2/token")!
    
    var request = URLRequest(url: tokenURL)
    request.httpMethod = "POST"
    
    // Create the Basic Authorization header
    if let authorization = concatenateAndEncodeBase64(string1: clientID, string2: clientSecret) {
        request.setValue("Basic \(authorization)", forHTTPHeaderField: "Authorization")
    }
    
    let parameters: [String: String] = [
        "grant_type": "client_credentials"
    ]
    
    request.httpBody = parameters.percentEncoded()
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            return
        }
        
        // Print the JSON data received
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Received JSON: \(jsonString)")
        } else {
            print("Failed to convert data to JSON string")
        }
        
        do {
            let decoder = JSONDecoder()
            let deliverooApi = try decoder.decode(DeliverooApiResponse.self, from: data)
            
            completion(.success(deliverooApi))
        } catch {
            print("JSON Decoding Error: \(error)")
            completion(.failure(error))
        }
    }
    
    task.resume()
}



//The following 2 extensions are used to encode data to the form data format
// SOURCE: https://sagar-r-kothari.github.io/swift/2020/02/20/Swift-Form-Data-Request.html
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

