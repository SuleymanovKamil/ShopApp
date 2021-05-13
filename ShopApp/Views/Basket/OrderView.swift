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
            
            CustomTextField(title: "Адрес", text: $address, textfieldTag: $tags, textfieldID: 1)
            
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


import Introspect

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    @Binding var textfieldTag: Int
    var textfieldID: Int
    
  
    
    var body: some View {
        ZStack (alignment: Alignment(horizontal: .leading, vertical: .center)){
            Text(title)
                .font(Font.system(size: text.isEmpty  && textfieldID != textfieldTag ? 16 : 12))
                .offset(y: text.isEmpty && textfieldTag != textfieldID ? 0 : -25)
                .zIndex(1)
            
            
            VStack {
                ZStack (alignment: Alignment(horizontal: .trailing, vertical: .center)){
                    TextField("", text: $text, onEditingChanged: { editing in
                        if !editing && textfieldTag != 0 && textfieldTag == textfieldID{
                            textfieldTag = textfieldID + 1
                        }
                    })
                    .accentColor(.black)
                    .foregroundColor(.primary)
                    
                   
                }
                
                Capsule()
                    .frame(height: 1)
                    .foregroundColor(textfieldTag == textfieldID ? .primary : .gray)
            }
          
        }
        .padding()
        .padding(.top, 5)
        .onTapGesture {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                textfieldTag = textfieldID
            }
        }
        .introspectTextField { textfield in
            textfield.returnKeyType = .next
            textfield.enablesReturnKeyAutomatically = true
            textfield.tag = textfieldID
            if textfield.tag == textfieldTag {
                textfield.becomeFirstResponder()
                
            } else {
                textfield.resignFirstResponder()
            }
        }
        
    }
}
