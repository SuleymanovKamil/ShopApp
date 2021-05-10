//
//  PopularItems.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import SwiftUI

struct PopularItems: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var basket: BasketViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            Text("Популярное")
                .font(.system(.title, design: .rounded))
                .bold()
                .padding([.leading, .top])
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack (spacing: 18) {
                    ForEach(store.popularsItems, id: \.self) { item in
                        NavigationLink(
                            destination: ItemDetailView(item: item).environmentObject(basket),
                            label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 3)
                                .frame(width: 150, height: 150)
                                .shadow(radius: 5)
                                .overlay(
                                    ZStack (alignment: Alignment(horizontal: .center, vertical: .bottom)){
                                        Image(item.image!)
                                            .resizable()
                                            .cornerRadius(10)
                                        
                                        Text(item.name)
                                            .font(.system(.subheadline, design: .rounded))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.01)
                                            .padding(5)
                                            .frame(width: 150)
                                            .background(Color.white)
                                            .offset(y: -15)
                                    }
                            )
                        })
                            .buttonStyle(FlatLinkStyle())
                            .simultaneousGesture(TapGesture().onEnded{
                                store.selectedItem = item
                                            })

                    }
                }
                .padding()
            }
        }
    }
}



struct PopularItems_Previews: PreviewProvider {
    static var previews: some View {
        PopularItems()
            .environmentObject(Store())
    }
}
