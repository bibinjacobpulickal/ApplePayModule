//
//  ContentView.swift
//  ApplePayModule
//
//  Created by Bibin Jacob Pulickal on 16/07/20.
//  Copyright © 2020 Bibin Jacob Pulickal. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    private let paymentHandler = ApplePayHandler()
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var paymentItems = [PaymentItem(title: "Amount", amount: "100.00"),
                                       .init(title: "Tax", amount: "20.00"),
                                       .init(title: "Total", amount: "120.00")]

    var body: some View {
        Button(action: {
            self.paymentHandler.startPayment(forItems: self.paymentItems) {
                self.alertTitle = $0 ? "Payment successful!" : "Payment Failed!"
                self.showAlert.toggle()
            }
        }, label: {
            Text("PAY WITH  APPLE PAY")
                .foregroundColor(.white)
        })
            .frame(width: 300, height: 20, alignment: .center)
            .padding()
            .background(Color.black)
            .cornerRadius(8)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
