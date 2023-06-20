import SwiftUI
import Stripe

struct PaymentGateway: View {
    @State private var cardHolderName: String = ""
    @State private var cardNumber: String = ""
    @State private var expirationMonth: String = ""
    @State private var expirationYear: String = ""
    @State private var cvc: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Text("Payment Gateway")
                .font(.largeTitle)
                .foregroundColor(Color("darkgray"))
                .padding(10)
            
            VStack {
                TextField("Cardholder Name", text: $cardHolderName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color("darkgray"), lineWidth: 1))
                    .padding()
                
                TextField("Card Number", text: $cardNumber)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color("darkgray"), lineWidth: 1))
                    .padding()
                
                HStack {
                    TextField("Expiration Month", text: $expirationMonth)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color("darkgray"), lineWidth: 1))
                        .padding()
                    
                    TextField("Expiration Year", text: $expirationYear)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color("darkgray"), lineWidth: 1))
                        .padding()
                }
                
                TextField("CVV", text: $cvc)
                    .foregroundColor(.black)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color("darkgray"), lineWidth: 1))
                    .padding()
            }
            .padding()
            Spacer()
            // Payment button
            Button(action: {
                processPayment()
            }) {
                Text("Pay")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .frame(maxWidth: 120)
            }
            .background(Color("darkgray"))
            .cornerRadius(70)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.blue, lineWidth: 0)
                    .foregroundColor(.black)
            )
        }
        .navigationBarTitle("", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Payment Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func processPayment() {
        STPAPIClient.shared.publishableKey = "pk_test_51NL5tXGqazpotKa3TAh4pTUeAUyNADf16KmzA0o6JVwEDSpRdD1myznjXzSm7CKcRQkq5F7amf5OUh4Bvd7Gf68b00gvi8wrbr"
        
       
        guard !cardNumber.isEmpty else {
            showAlert = true
            alertMessage = "Please enter a valid card number."
            return
        }
        
        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = cardNumber
        cardParams.expMonth = UInt(expirationMonth) as NSNumber? ?? 0
        cardParams.expYear = UInt(expirationYear) as NSNumber? ?? 0
        cardParams.cvc = cvc
        
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        STPAPIClient.shared.createPaymentMethod(with: paymentMethodParams) { (paymentMethod, error) in
            if let error = error {
                self.showAlert = true
                self.alertMessage = "Payment failed. Error: \(error.localizedDescription)"
            } else if let paymentMethod = paymentMethod {
                self.processStripePayment(paymentMethod: paymentMethod)
            }
        }
    }
    
    private func processStripePayment(paymentMethod: STPPaymentMethod) {
      
        self.showAlert = true
        self.alertMessage = "Payment successful! Thank you."
    }
}

struct PaymentGateway_Previews: PreviewProvider {
    static var previews: some View {
        PaymentGateway()
    }
}
