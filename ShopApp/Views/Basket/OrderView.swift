//
//  OrderView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 12.05.2021.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var store: Store
    let paymentHandler = PaymentHandler()
    @State var address = ""
    @State var wishes = ""
    @State var tags = 0
    
    var body: some View {
        VStack {
            
            Text("Детали заказа на сумму:  \(store.totalSum)₽")
                .font(.title3)
                .bold()
                .padding(.top, 60)
            
            Divider()
            
            CustomTextField(title: "Адрес", text: $address)
            
            VStack (alignment: .leading){
                Text("Примечение к заказу:")
                TextEditor(text: $wishes)
                    .frame(height: 100)
                 
            }
            .padding(.horizontal)
            Spacer()
            
            Button(action: {
                self.paymentHandler.startPayment { (success) in
                    if success {
                        print("Success")
                    } else {
                        print("Failed")
                    }
            }
            }, label: {
                Text("Заплатить с  Pay")
                    .foregroundColor(Color("darkMode"))
                    .padding(10)
                    .padding(.horizontal, 30)
                    .background(Color.primary.cornerRadius(5))
            })

        }
        .edgesIgnoringSafeArea(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.05).ignoresSafeArea())
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
            .environmentObject(Store())
    }
}




