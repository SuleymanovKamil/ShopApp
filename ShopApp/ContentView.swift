//
//  ContentView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = Store()
    @StateObject var basket = BasketViewModel()
    
    var body: some View {
        NavigationView {
          TabBar()
            .environmentObject(store)
            .environmentObject(basket)
            .navigationBarHidden(true)
            .navigationBarTitle("")
        }
        .accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
