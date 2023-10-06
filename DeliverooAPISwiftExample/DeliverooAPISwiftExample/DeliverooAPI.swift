//
//  DeliverooAPI.swift
//  DeliverooAPISwiftExample
//
//  Created by Ahmed Henna on 10/6/23.
//

import Foundation

// MARK: - Requesting Access Token
func requestDeliverooApiToken(clientID: String, clientSecret: String, completion: @escaping (Result<DeliverooApiResponse, Error>) -> Void) {
    let tokenURL = URL(string: Constants.AUTH_URL_DELIVEROO)!
    
    var request = URLRequest(url: tokenURL)
    request.httpMethod = "POST"
    
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

// MARK: - Requesting Orders
func requestAllOrders(brandID: String, restaurantID: String, accessToken: String, completion: @escaping (Result<[Order], Error>) -> Void) {
    let baseURL = "\(Constants.ORDERS_DELIVEROO)\(brandID)/restaurant/\(restaurantID)/orders"
    
    guard let finalURL = buildURL(baseURL: baseURL) else {
        print("Error creating the final URL")
        return
    }
    
    var request = URLRequest(url: finalURL)
    request.httpMethod = "GET"
    
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    executeRequest(request: request, completion: completion)
}

func buildURL(baseURL: String) -> URL? {
    let calendar = Calendar.current
    let now = Date()
    let startOfDay = calendar.startOfDay(for: now)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    let startDateString = dateFormatter.string(from: startOfDay)
    
    var components = URLComponents(string: baseURL)
    components?.queryItems = [URLQueryItem(name: "start_date", value: startDateString)]
    
    return components?.url
}

func executeRequest(request: URLRequest, completion: @escaping (Result<[Order], Error>) -> Void) {
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
        
        do {
            let decoder = JSONDecoder()
            let orderResponse = try decoder.decode(OrderResponse.self, from: data)
            
            // Extract the orders from the response
            let orders = orderResponse.orders
            
            completion(.success(orders))
        } catch {
            print("JSON Decoding Error: \(error)")
            completion(.failure(error))
        }
    }
    
    task.resume()
}

// MARK: - Get Restarant Location
func requestRestaurants(accessToken: String, latitude: Double, longitude: Double, completion: @escaping (Result<[Restaurant], Error>) -> Void) {
    let baseURL = Constants.RESTAURANT_LOCATION
    
    guard let finalURL = buildURL(baseURL: baseURL, latitude: latitude, longitude: longitude) else {
        print("Error creating the final URL")
        return
    }
    
    var request = URLRequest(url: finalURL)
    request.httpMethod = "GET"
    
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    executeRequest(request: request, completion: completion)
}

func buildURL(baseURL: String, latitude: Double, longitude: Double) -> URL? {
    var components = URLComponents(string: baseURL)
    components?.queryItems = [
        URLQueryItem(name: "latitude", value: String(latitude)),
        URLQueryItem(name: "longitude", value: String(longitude))
    ]
    
    return components?.url
}

func executeRequest(request: URLRequest, completion: @escaping (Result<[Restaurant], Error>) -> Void) {
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
        
        do {
            let decoder = JSONDecoder()
            let restaurants = try decoder.decode([Restaurant].self, from: data)
            completion(.success(restaurants))
        } catch {
            print("JSON Decoding Error: \(error)")
            completion(.failure(error))
        }
    }
    
    task.resume()
}

// MARK: - Update Order Status
func updateOrderStatus(accessToken: String, orderId: String, newStatus: String, completion: @escaping (Result<Void, Error>) -> Void) {
    let baseURL = "\(Constants.ORDER_STATUS)\(orderId)"
    
    guard let finalURL = URL(string: baseURL) else {
        print("Error creating the final URL")
        return
    }
    
    var request = URLRequest(url: finalURL)
    request.httpMethod = "PATCH"
    
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let requestBody = buildRequestBody(newStatus: newStatus)
    request.httpBody = requestBody
    
    executePatchRequest(request: request, completion: completion)
}

func buildRequestBody(newStatus: String) -> Data? {
    let requestBody: [String: Any] = ["status": newStatus]
    return try? JSONSerialization.data(withJSONObject: requestBody)
}

func executePatchRequest(request: URLRequest, completion: @escaping (Result<Void, Error>) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            completion(.failure(error))
            return
        }
        
        // Check the HTTP response status code for success (e.g., 200 OK)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            completion(.success(()))
        } else {
            print("HTTP response status code indicates an error")
            completion(.failure(NSError(domain: "HTTP Error", code: 0, userInfo: nil)))
        }
    }
    task.resume()
}



// MARK: - Extensions
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
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
