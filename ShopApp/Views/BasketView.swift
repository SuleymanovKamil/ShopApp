//
//  BasketView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 10.05.2021.
//

import SwiftUI

struct BasketView: View {
    @EnvironmentObject var store: Store
    let paymentHandler = PaymentHandler()
    
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("Товаров в корзине: ")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Text("\(store.basket.count)")
                    .bold()
            }
            .font(.title3)
            .padding()
            
            List{
                    ForEach(store.basket, id: \.self) { item in
                        HStack {
                    
                            Image(item.item.image!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 70)
                                .cornerRadius(6)
                            
                            Spacer()
                            
                            VStack (alignment: .trailing, spacing: 0){

                                    Text(item.item.name)
                                    Text("Количество: \(item.quantity)шт.")
                                Text("Цена: \(item.item.price * item.quantity)₽")
                              
                            
                                Spacer()
                            }
                         
                        }
                    }
                    .onDelete(perform: delete)
            }
            
            HStack {
                
              
                Button(action: {
                    paymentHandler.ammount = Double(store.totalSum)
                    paymentHandler.startPayment { (success) in
                        if success {
                            print("Success")
                            store.basket.removeAll()
                        } else {
                            print("Failed")
                        }
                }
                }, label: {
                    Text("Заплатить с Pay")
                        .foregroundColor(Color("darkMode"))
                        .padding(10)
                        .padding(.horizontal)
                        .background(Color.primary.cornerRadius(5))
                })

                
                Spacer()
                Text("Итого: \(store.totalSum)₽")
                    .font(.title3)
                    .bold()
                   
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    func delete(at offsets: IndexSet) {
        store.basket.remove(atOffsets: offsets)
       }
}

struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView()
            .environmentObject(Store())
    }
}

