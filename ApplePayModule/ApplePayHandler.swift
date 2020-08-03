//
//  ApplePayHandler.swift
//  ApplePayModule
//
//  Created by Bibin Jacob Pulickal on 24/07/20.
//  Copyright © 2020 Bibin Jacob Pulickal. All rights reserved.
//

import PassKit

typealias ApplePayCompletionHandler = (Bool) -> Void

class ApplePayHandler: NSObject {

    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: ApplePayCompletionHandler?

    func startPayment(forItems items: [PaymentItem], completion: @escaping ApplePayCompletionHandler) {

        paymentStatus     = .failure
        completionHandler = completion

        let paymentRequest                 = generateRequest(forItems: items.map(PKPaymentSummaryItem.init))
        let paymentAuthorizationController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)

        paymentAuthorizationController.delegate = self
        paymentAuthorizationController.present {
            if !$0 {
                print("Error: Failed to present payment controller")
                self.completionHandler?(false)
            }
        }
    }

    private func generateRequest(forItems items: [PKPaymentSummaryItem]) -> PKPaymentRequest {

        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems  = items
        paymentRequest.merchantIdentifier   = "merchant.com.fingent.applepay"
        paymentRequest.merchantCapabilities = .capability3DS

        paymentRequest.countryCode  = "IN"
        paymentRequest.currencyCode = "INR"

        paymentRequest.requiredShippingContactFields = [.phoneNumber, .emailAddress]
        paymentRequest.supportedNetworks             = [.amex, .masterCard, .visa]

        return paymentRequest
    }
}

extension ApplePayHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                        didAuthorizePayment payment: PKPayment,
                                        completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

        if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
            print("Error: Failed to authorize payment controller")
            paymentStatus = .failure
        } else {
            paymentStatus = .success
        }
        completion(paymentStatus)
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                self.completionHandler?(self.paymentStatus == .success)
            }
        }
    }
}
