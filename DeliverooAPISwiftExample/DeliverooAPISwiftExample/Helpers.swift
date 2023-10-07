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

func formatMonetaryValue(value: Int) -> String {
    let formattedValue = Double(value) / 100.0
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.minimumFractionDigits = 2
    
    if let formattedString = numberFormatter.string(from: NSNumber(value: formattedValue)) {
        return formattedString
    } else {
        return ""
    }
}

func getDistanceForRestaurant(withId idToFind: String, in restaurants: [Restaurant]) -> Double? {
    if let restaurant = restaurants.first(where: { $0.id == idToFind }) {
        let distanceInMiles = Double(restaurant.distance) / 1609.34
        return distanceInMiles
    }
    return nil
}


func calculateResult(price: Int, distance: Double) -> Bool {
    if price >= 1500 && price < 20 && distance <= 1.5{
        return true
    }
    
    if price >= 2000 && price < 25 && distance <= 2.0{
        return true
    }
    
    if price >= 2500 && price < 30 && distance <= 3.0{
        return true
    }
        
    if price >= 3000 && price < 35 && distance <= 3.5{
        return true
    }
    
    if price >= 3500 && price < 40 && distance <= 3.5{
        return true
    }
    
    if price >= 4000 && distance <= 4.0{
        return true
    }
    
    return false
}

