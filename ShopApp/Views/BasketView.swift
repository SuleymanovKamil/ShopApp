//
//  BasketView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 10.05.2021.
//

import SwiftUI

struct BasketView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var basket: BasketViewModel
    
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("Товаров в корзине: ")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Text("\(basket.basket.count)")
                    .bold()
            }
            .font(.title3)
            .padding()
            
            List{
                    ForEach(basket.basket, id: \.self) { item in
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
                Button(action: {}, label: {
                    Text("Заказать")
                        .font(.title2)
                        .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.primary.cornerRadius(10))
                })

                
                Spacer()
                Text("Итого: \(basket.totalSum)₽")
                    .font(.title3)
                    .bold()
                   
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    func delete(at offsets: IndexSet) {
        basket.basket.remove(atOffsets: offsets)
       }
}

struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView()
            .environmentObject(Store())
            .environmentObject(BasketViewModel())
    }
}

