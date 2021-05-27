//
//  ContentView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = Store()
    
    var body: some View {
        NavigationView {
          TabBar()
            .environmentObject(store)
            .navigationBarHidden(true)
            .navigationBarTitle("")
            .onAppear{
    //            store.saveItemsToFirebase()
                store.fetchAdmins()
                    store.fetchCurrenUser()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


