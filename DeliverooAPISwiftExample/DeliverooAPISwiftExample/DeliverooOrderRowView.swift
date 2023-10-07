//
//  DeliverooOrderRowView.swift
//  DeliverooAPISwiftExample
//
//  Created by Ahmed Henna on 10/7/23.
//

import SwiftUI


struct DeliverooOrderRowView: View {
    var order: Order
    var accessToken: String
    @State private var isPopupVisible = false

    var body: some View {
        VStack {
            let orderPrice = formatMonetaryValue(value: order.subtotal.fractional)
            Text("Order ID: \(order.id)")
            Text("Total Price: \(orderPrice) \(order.subtotal.currency_code)")
        }
        .onTapGesture {
            isPopupVisible.toggle()
        }
        .sheet(isPresented: $isPopupVisible) {
            DeliverooOrderPopupView(order: order,
                                    accessToken: accessToken,
                                    isPresented: $isPopupVisible)
        }
    }
}

#Preview {
    DeliverooOrderRowView(order: Order(id: "1", order_number: "1", subtotal: Subtotal(fractional: 400, currency_code: "GBP"), location: Location(latitude: 40, longitude: 40)), accessToken: "skjdksj")
}
