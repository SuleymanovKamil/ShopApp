//
//  ItemDetailView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 10.05.2021.
//

import SwiftUI
import Firebase

struct ItemDetailView: View {
    @EnvironmentObject var store: Store
    @State private var itemCount = 1
    
    var item: Item
    
    var body: some View {
        VStack (spacing: 20){
            
            Image(uiImage: Utility.shared.base64ToImage(item.image!) ?? #imageLiteral(resourceName: "placeholder"))
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth)
                .cornerRadius(30)
                .edgesIgnoringSafeArea(.top)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
            
            VStack{
                Text(item.name)
                    .font(.system(.title, design: .rounded))
                    .bold()
                
                Text("Цена: \(String(format: "%.0f", item.price))₽")
                    .font(.system(.title2, design: .rounded))
                
                
                HStack (spacing: 20){
                    Button(action: {if itemCount > 1 {itemCount -= 1}}, label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    })
                    
                    Text("\(itemCount)шт.")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Button(action: {itemCount += 1}, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    }) 
                }
                .padding()
            }
            
            Button(action: {
                
                if  !store.basket.contains(where: { $0.item.name == item.name}) {
                    store.basket.append(BasketItem(item: item, quantity: itemCount))
                    store.saveBasketToFirebase()
                } else {
                    var i = Int()
                    for index in 0..<store.basket.count{
                        if store.basket[index].item == item{
                              i = index
                                print(store.basket[i].item.name)
                            }
                    }
                    store.basket[i].quantity = itemCount
                    store.saveBasketToFirebase()
                }
            }, label: {
                Text(store.basket.contains(where: { $0.item == item}) ? (store.basket.contains(where: { $0.quantity == itemCount}) ? "Добавлено"  : "Изменить количество"): "Добавить")
                    .font(.title2)
                    .foregroundColor(Color("darkMode"))
                    .fixedSize()
                    .padding(.vertical, 10)
                    .frame(width: 300)
                    .background(Color.primary.cornerRadius(10))
            })
            
            Spacer()
        }
        .onAppear{
            print(store.basket.count)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.05).ignoresSafeArea())
        .navigationBarItems(trailing:
                                NavigationLink(
                                    destination:  EditItem(item: item),
                                    label: {
                                        Image(systemName: "square.and.pencil")
                                    }))
    }
  
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item:   Item(name: "Американо", price: 110, category: Category(name: "coffee"), quantity: nil, description: nil, image: "coffee1", isPopular: false))
            .environmentObject(Store())
    }
}
