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

struct OrderResponse: Codable {
    let orders: [Order]
    let next: String?
}

struct Order: Codable {
    let id: String
    let order_number: String
    let subtotal: Subtotal
    let location: Location
}

struct Subtotal: Codable {
    let fractional: Int
    let currency_code: String
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

struct Restaurant: Codable {
    let id: String
    let distance: Int
    let location: RestaurantLocation
    let name: String
    let display_name: String
}

struct RestaurantLocation: Codable {
    let lat: Double
    let lon: Double
}

struct RestaurantInfo: Codable {
    let name: String
    let id: String
}

