//
//  MainscreenView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import SwiftUI

struct MainscreenView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var basket: BasketViewModel
    
    var body: some View {
        VStack (alignment: .leading){
            
            Searchbar()
            
            ScrollView(showsIndicators: false) {
                
                PopularItems()
                
                Catalog()
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .environmentObject(basket)
      
    }
}

struct MainscreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainscreenView()
            .environmentObject(Store())
    }
}



