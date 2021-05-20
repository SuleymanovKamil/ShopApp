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
    var body: some View {
        VStack (alignment: .leading){
            
            Searchbar()
            
            ScrollView(showsIndicators: false) {
                
                PopularItems()
                
                Catalog()
                
                Spacer()
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear{
//            store.saveItemsToFirebase()
            store.fetchAdmins()
            if store.currentItems.isEmpty{
                store.fetchCategories()
                store.fetchPopularItems()
            store.fetchItems()
            }
        }
       
      
    }
}

struct MainscreenView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



