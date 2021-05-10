//
//  SearchBar.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import SwiftUI

struct Searchbar: View {
    @EnvironmentObject var store: Store
    var body: some View {
        HStack {
            TextField("Поиск", text: $store.search)
            
            Button(action: {
                store.search = ""
            }) {
                Image(systemName: "xmark.circle.fill").opacity(store.search == "" ? 0 : 1)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .foregroundColor(.secondary)
        .background(Color(.white).cornerRadius(10))
        .padding([.top,.horizontal])
    }
}
