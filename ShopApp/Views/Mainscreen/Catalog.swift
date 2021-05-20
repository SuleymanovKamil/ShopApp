//
//  Catalog.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 10.05.2021.
//

import SwiftUI
import Firebase

struct Catalog: View {
    @EnvironmentObject var store: Store
    @State private var addCategory = false
    @State private var addItem = false
    @State private var edit = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            HStack {
                Text("Меню")
                    .font(.system(.title, design: .rounded))
                    .bold()
                    .padding([.leading, .top])
                
                Spacer()
                
                if store.isCurrentUserAdmin {
                    HStack{
                    Button(action: {addCategory = true}, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.primary)
                            
                    })
                    .sheet(isPresented: $addCategory, content: {
                        AddNewCategory()
                    })
                    
                    Button(action: {addItem = true}, label: {
                        Image(systemName: "externaldrive.fill.badge.plus")
                            .font(.title)
                            .foregroundColor(.primary)
                            
                    })
                    .sheet(isPresented: $addItem, content: {
                        AddNewItem()
                    })
                        
                        Button(action: {edit.toggle()}, label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                                
                        })
                    }
                    .padding([.trailing, .top])
                }
            }
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(store.categories.removeDuplicates(), id: \.self) { category in
                        ZStack (alignment: Alignment(horizontal: .trailing, vertical: .center)){
                            Image(systemName: "trash.circle.fill")
                                .renderingMode(.original)
                                .font(.title2)
                                .zIndex(1)
                                .offset(x: 10, y: -10)
                                .opacity(edit ? 1 : 0)
                                .onTapGesture {
                                        deleteFromFireBase(name: category.name)
                                }
                            
                            Text(category.name)
                                .font(.system(.headline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(store.currentCategory == category.name ? .black : .gray)
                                .padding(5)
                                .padding(.horizontal, 5)
                                .background(Color.white.cornerRadius(8).shadow(radius: 2))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.3))
                                .onTapGesture {
                                    store.currentCategory = category.name
                                    store.fetchItems()
                            }
                        }
                    }
                }
                .padding(.vertical, 5)
                .padding([.leading, .bottom])
            }
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 150),spacing: screenWidth * 0.05, alignment: .center), count: 1),spacing:  screenWidth * 0.05){
                    ForEach(store.currentItems.removeDuplicates(), id: \.self) { item in
                        
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
                                            Image(uiImage: Utility.shared.base64ToImage(item.image!) ?? #imageLiteral(resourceName: "placeholder"))
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
                                                    
                                                    Text("\(String(format: "%.0f", item.price))₽")
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
    
    func deleteFromFireBase (name: String){
    
            let db = Firestore.firestore()
        db.collection("Categories").document(name).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                store.categories.remove(object: Category(name: name))
            }
        }
        }
}


struct Catalog_Previews: PreviewProvider {
    static var previews: some View {
        Catalog()
    }
}

