import Flutter
import UIKit
import StoreKit

@main
@objc class AppDelegate: FlutterAppDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var product: SKProduct?
    var flutterResult: FlutterResult?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Get the Flutter root view controller
        let controller = window?.rootViewController as! FlutterViewController

        // Create the method channel
        let channel = FlutterMethodChannel(name: "in_app_purchase_channel", binaryMessenger: controller.binaryMessenger)

        // Set method call handler
        channel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "isPremiumActive":
                let isActive = UserDefaults.standard.bool(forKey: "isPremium")
                result(isActive)
            case "buyPremium":
                self?.flutterResult = result
                self?.buyPremium()
            case "restorePurchases":
                self?.flutterResult = result
                SKPaymentQueue.default().restoreCompletedTransactions()
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        // Add transaction observer
        SKPaymentQueue.default().add(self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func buyPremium() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: ["premium_vip"])
            request.delegate = self
            request.start()
        } else {
            flutterResult?(false)
        }
    }

    // MARK: - SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let premiumProduct = response.products.first {
            self.product = premiumProduct
            let payment = SKPayment(product: premiumProduct)
            SKPaymentQueue.default().add(payment)
        } else {
            flutterResult?(false)
        }
    }

    // MARK: - SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                UserDefaults.standard.set(true, forKey: "isPremium")
                SKPaymentQueue.default().finishTransaction(transaction)
                flutterResult?(true)
            case .restored:
                UserDefaults.standard.set(true, forKey: "isPremium")
                SKPaymentQueue.default().finishTransaction(transaction)
                flutterResult?(true)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                flutterResult?(false)
            default:
                break
            }
        }
    }
}