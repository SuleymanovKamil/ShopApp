//
//  MainscreenView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import SwiftUI

struct MainscreenView: View {
    @EnvironmentObject var store: Store
    
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
      
    }
}

struct MainscreenView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



