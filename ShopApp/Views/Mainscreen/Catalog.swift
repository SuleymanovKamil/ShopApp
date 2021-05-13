//
//  Catalog.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 10.05.2021.
//

import SwiftUI

struct Catalog: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            Text("Меню")
                .font(.system(.title, design: .rounded))
                .bold()
                .padding([.leading, .top])
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<store.categories.count, id: \.self) { index in
                        Text(store.categories[index])
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(store.currentCategory == store.categories[index] ? .black : .gray)
                            .padding(5)
                            .padding(.horizontal, 5)
                            .background(Color.white.cornerRadius(8).shadow(radius: 2))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.3))
                            .onTapGesture {
                                store.currentCategory = store.categories[index]
                                store.getItems(named: store.categories[index])
                            }
                    }
                }
                .padding(.vertical, 5)
                .padding([.leading, .bottom])
                .onAppear{
                    store.getItems(named: store.currentCategory)
                }
            }
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 150),spacing: screenWidth * 0.05, alignment: .center), count: 1),spacing:  screenWidth * 0.05){
                    ForEach(store.currentItems, id: \.self) { item in
                        
                        NavigationLink(
                            destination: ItemDetailView(item: item).environmentObject(store),
                            label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(radius: 3)
                                    .frame(height: 250)
                                    .shadow(radius: 5)
                                    .overlay(
                                        VStack{
                                            Image(item.image!)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(CustomCorner(corners: [.topLeft, .topRight]))
                                            
                                            Spacer()
                                            
                                            VStack (spacing: 4){
                                                Text(item.name)
                                                    .font(.system(.headline, design: .rounded))
                                                    .foregroundColor(.black)
                                                    .lineLimit(1)
                                                
                                                HStack {
                                                    Image(systemName: "minus.circle.fill")
                                                        .font(.title3)
                                                        .foregroundColor(.red)
                                                        .opacity(0)
                                                    
                                                    Text("\(item.price)₽")
                                                        .foregroundColor(.black)
                                                    
                                                    Image(systemName: "plus.circle.fill")
                                                        .font(.title3)
                                                        .foregroundColor(.black)
                                                        .opacity(0)
                                                }
                                            }
                                        }
                                    )
                            })
                            .buttonStyle(FlatLinkStyle())
                    }
                }
                .padding()
            }
        }
        .padding(.bottom, 80)
       
    }
}


struct Catalog_Previews: PreviewProvider {
    static var previews: some View {
        Catalog()
    }
}
