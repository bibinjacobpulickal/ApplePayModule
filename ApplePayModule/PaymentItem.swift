//
//  PaymentItem.swift
//  ApplePayModule
//
//  Created by Bibin Jacob Pulickal on 28/07/20.
//  Copyright © 2020 Bibin Jacob Pulickal. All rights reserved.
//

import Foundation
import PassKit

struct PaymentItem: Identifiable, Equatable {
    let id = UUID()
    let title, amount: String
}

extension PKPaymentSummaryItem {

    convenience init(_ paymentItem: PaymentItem) {
        self.init(label: paymentItem.title, amount: NSDecimalNumber(string: paymentItem.amount))
    }
}
