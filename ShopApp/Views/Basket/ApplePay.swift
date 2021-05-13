//
//  ApplePay.swift
//  applePay
//
//  Created by Камиль on 15.10.2020.
//

import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {
    
    var ammount = 20.0
    
static let supportedNetworks: [PKPaymentNetwork] = [
    .masterCard,
    .visa
]

var paymentController: PKPaymentAuthorizationController?
var paymentSummaryItems = [PKPaymentSummaryItem]()
var paymentStatus = PKPaymentAuthorizationStatus.failure
var completionHandler: PaymentCompletionHandler?

func startPayment(completion: @escaping PaymentCompletionHandler) {

    let total = PKPaymentSummaryItem(label: "Итого", amount: NSDecimalNumber(string: "\(ammount)"), type: .final)

    paymentSummaryItems = [total];
    completionHandler = completion

    // Create our payment request
    let paymentRequest = PKPaymentRequest()
    paymentRequest.paymentSummaryItems = paymentSummaryItems
    paymentRequest.merchantIdentifier = "merchant.com.YOURDOMAIN.YOURAPPNAME"
    paymentRequest.merchantCapabilities = .capability3DS
    paymentRequest.countryCode = "RU"
    paymentRequest.currencyCode = "RUB"
    paymentRequest.requiredShippingContactFields = [.phoneNumber, .emailAddress, .postalAddress]
    paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks

    // Display our payment request
    paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
    paymentController?.delegate = self
    paymentController?.present(completion: { (presented: Bool) in
        if presented {
            NSLog("Presented payment controller")
        } else {
            NSLog("Failed to present payment controller")
            self.completionHandler!(false)
         }
     })
  }
}

/*
    PKPaymentAuthorizationControllerDelegate conformance.
*/
extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

    // Perform some very basic validation on the provided contact information
    if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
        paymentStatus = .failure
    } else {
        // Here you would send the payment token to your server or payment provider to process
        // Once processed, return an appropriate status in the completion handler (success, failure, etc)
        paymentStatus = .success
    }

    completion(paymentStatus)
}

func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
    controller.dismiss {
        DispatchQueue.main.async {
            if self.paymentStatus == .success {
                self.completionHandler!(true)
            } else {
                self.completionHandler!(false)
            }
        }
    }
}

}
