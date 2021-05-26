//
//  BasketView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 10.05.2021.
//

import SwiftUI
import Firebase

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
            PullToRefresh(content: {
                List{
                    ForEach(store.basket, id: \.self) { item in
                        NavigationLink(
                            destination: ItemDetailView(item: item.item).environmentObject(store),
                            label: {
                            HStack {
                                
                                Image(uiImage: Utility.shared.base64ToImage(item.item.image!) ?? #imageLiteral(resourceName: "placeholder"))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 70)
                                    .cornerRadius(6)
                                
                                Spacer()
                                
                                VStack (alignment: .trailing, spacing: 0){
                                    
                                    Text(item.item.name)
                                    Text("Количество: \(item.quantity)шт.")
                                    Text("Цена: \( String(format: "%.0f", item.item.price * Double(item.quantity)))₽")
                                    
                                    
                                    Spacer()
                                }
                                
                            }
                        })
                        }
                    .onDelete(perform: delete)
                    
                }
            },  onRefresh: {control in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    //add task for refresh
                    control.endRefreshing()
                }
            })
            
            HStack {
                
                Button(action: {
                    paymentHandler.ammount = Double(store.totalSum)
                    paymentHandler.startPayment { (success) in
                        if success {
                            print("Success")
                            store.saveOrderToFirebase()
                            store.basket.removeAll()
                            deleteBsketFromFireBase()
                            
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
                        .fixedSize()
                })
                
                Spacer()
                Text("Итого: \(String(format: "%.0f", store.totalSum))₽")
                    .font(.title3)
                    .bold()
                
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    func delete(at offsets: IndexSet) {
        store.basket.remove(atOffsets: offsets)
        store.saveBasketToFirebase()
    }
    
    func deleteBsketFromFireBase(){
        let db = Firestore.firestore()
        db.collection("Basket").document(currentUser ?? currentDevice).delete(){ err in
            if let err = err {
                print("Error removing basket: \(err)")
            }
        }
    }
    
   
}

struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView()
            .environmentObject(Store())
    }
}



