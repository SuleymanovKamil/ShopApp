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
    @State private var edit = false
    @AppStorage("log_Status") var status = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            HStack {
                Text(store.title)
                    .font(.system(.title, design: .rounded))
                    .bold()
                
                if store.isCurrentUserAdmin && status{
                    NavigationLink(
                        destination:   EditTitles().environmentObject(store),
                        label: {
                            Image(systemName: "square.and.pencil")
                                .font(.title3)
                                .foregroundColor(.primary)
                        })
                }
                Spacer()
                
                if store.isCurrentUserAdmin && status{
                    HStack{
                        NavigationLink(
                            destination:   AddNewCategory(),
                            label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.primary)
                            })
                        
                        
                        NavigationLink(
                            destination:   AddNewItem(),
                            label: {
                                Image(systemName: "externaldrive.fill.badge.plus")
                                    .font(.title)
                                    .foregroundColor(.primary)
                            })
                        
                        
                        Button(action: {edit.toggle()}, label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        })
                    }
                }
            }
            .padding()
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(store.categories.reversed(), id: \.self) { category in
                        ZStack (alignment: Alignment(horizontal: .trailing, vertical: .center)){
                            Image(systemName: "trash.circle.fill")
                                .renderingMode(.original)
                                .font(.title2)
                                .zIndex(1)
                                .offset(x: 10, y: -10)
                                .opacity(edit ? 1 : 0)
                                .onTapGesture {
                                    deleteFromFireBase(collection: "Categories", document: category.name, comletion: {
                                        store.categories.remove(object: Category(name: category.name))
                                    })
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
                                        ZStack (alignment: Alignment(horizontal: .trailing, vertical: .top)){
                                            Image(systemName: "trash.circle.fill")
                                                .renderingMode(.original)
                                                .font(.title)
                                                .zIndex(1)
                                                .offset(x: 10, y: -10)
                                                .opacity(edit ? 1 : 0)
                                                .onTapGesture {
                                                    deleteFromFireBase(collection: "Items", document: item.name, comletion: {
                                                        store.currentItems.remove(object: Item(name: item.name, price: item.price, category: item.category, quantity: item.quantity, description: item.description, image: item.image, isPopular: item.isPopular))
                                                    })
                                                }
                                            VStack{
                                                Image(uiImage: Utility.shared.base64ToImage(item.image!) ?? #imageLiteral(resourceName: "placeholder"))
                                                    .resizable()
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
    
    func deleteFromFireBase (collection: String, document name: String, comletion: @escaping () -> Void){
        
        let db = Firestore.firestore()
        db.collection(collection).document(name).delete(){ err in
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

