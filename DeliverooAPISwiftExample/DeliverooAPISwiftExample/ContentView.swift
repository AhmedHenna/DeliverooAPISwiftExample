//
//  ContentView.swift
//  DeliverooAPISwiftExample
//
//  Created by Ahmed Henna on 10/6/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Hello"){
                requestDeliverooApiToken(clientID: Constants.CLIENT_ID, clientSecret: Constants.CLIENT_SECRET) { result in
                    switch result{
                    case .success(let deliverooApi):
                        print("Access", deliverooApi.access_token)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
