//
//  DeliverooOrderPopUpView.swift
//  DeliverooAPISwiftExample
//
//  Created by Ahmed Henna on 10/7/23.
//

import SwiftUI

struct DeliverooOrderPopupView: View {
    var order: Order
    var accessToken: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            text
            buttons
        }
        .padding()
    }
    
    var text: some View{
        VStack{
            let orderPrice = formatMonetaryValue(value: order.subtotal.fractional)
            Text("Order ID: \(order.id)")
            Text("Total Price: \(orderPrice) \(order.subtotal.currency_code)")
        }
    }
    
    var buttons: some View{
        HStack{
            Button("Accept") {
                acceptButton(accessToken: accessToken, order: order)
                isPresented = false
            }
            Button("Deny") {
                updateOrderStatus(accessToken: accessToken, orderId: order.id, newStatus: Constants.REJCET) { _ in
                    print("Order Rejected")
                }
                isPresented = false
            }
        }
    }
}

func acceptButton(accessToken: String, order: Order) {
    requestRestaurantInfo(accessToken: accessToken, orderId: order.id) { restaurant in
        switch restaurant{
        case .success(let info):
            requestRestaurants(accessToken: accessToken, latitude: order.location.latitude, longitude: order.location.longitude) { result in
                switch result{
                case .success(let restaurants):
                    let distance = getDistanceForRestaurant(withId: info.id, in: restaurants)
                    
                    let decision = calculateResult(price: order.subtotal.fractional, distance: distance ?? 0)
                    
                    if decision == true{
                        updateOrderStatus(accessToken: accessToken, orderId: order.id, newStatus: Constants.REJCET) { outcome in
                            print(outcome)
                            // TODO: Here is where you are supposed to call the function to deliver using your own guys delivery system
                        }
                        
                    }else{
                        //This accepts the order from deliveroo
                        updateOrderStatus(accessToken: accessToken, orderId: order.id, newStatus: Constants.ACCEPT) { outcome in
                            print(outcome)
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        case .failure(let error):
            print(error.localizedDescription)
            
        }
    }
}

