//
//  ContentView.swift
//  DeliverooAPISwiftExample
//
//  Created by Ahmed Henna on 10/6/23.
//

import SwiftUI

struct ContentView: View {
    @State private var allOrders: [Order] = []
    @State private var accessToken: String = ""
    
    var body: some View {
        VStack {
            buttons
            displayDeliverooOrders
        }
        .padding()
    }
    
    var buttons : some View{
        VStack{
            Button("Request Token"){
                requestDeliverooApiToken(clientID: Constants.CLIENT_ID_DELIVEROO,
                                         clientSecret: Constants.CLIENT_SECRET_DELIVEROO) { result in
                    switch result{
                    case .success(let deliverooApi):
                        accessToken = deliverooApi.access_token
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Refresh Orders"){
                requestAllOrders(brandID: "brand_id",
                                 restaurantID: "restaurant_id",
                                 accessToken: accessToken) { result in
                    switch result {
                    case .success(let orders):
                        allOrders = orders
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    var displayDeliverooOrders: some View {
        ScrollView {
            ForEach(allOrders, id: \.id) { deliverooOrder in
                DeliverooOrderRowView(order: deliverooOrder, accessToken: accessToken)
            }
        }
    }

    
}

#Preview {
    ContentView()
}
