//
//  MainscreenView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import SwiftUI

struct MainscreenView: View {
    @EnvironmentObject var store: Store
    @State private var addCategory = false
    @State private var onTap = false
    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .top)){
          
                Searchbar(onTap: $onTap)
                    .zIndex(1)
            
            VStack (alignment: .leading){
                ScrollView(showsIndicators: false) {
                    PopularItems()
                    
                    Catalog()
                    
                    Spacer()
                }
            }
            .padding(.top, 70)
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear{
    //            store.saveItemsToFirebase()
                store.fetchAdmins()
                if store.currentItems.isEmpty{
                    store.fetchCategories()
                    store.fetchPopularItems()
                    store.fetchTitles()
                }
                if store.basket.isEmpty {
                    store.fetchBasketFromFirebase()
                    print("load basket")
                }
        }
        }
       
      
    }
}

struct MainscreenView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



