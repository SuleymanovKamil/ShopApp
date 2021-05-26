//
//  SearchBar.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import SwiftUI
import Introspect

struct Searchbar: View {
    @EnvironmentObject var store: Store
    @Binding var onTap: Bool
    var body: some View {
        GeometryReader { _ in
            VStack {
                HStack {
                    HStack {
                        TextField("Поиск", text: $store.search)
                            .onChange(of: store.search, perform: { value in
                                if store.search.count > 1 {
                                    store.startSearch()
                                }
                            })
                        Button(action: {
                            store.search = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(store.search == "" ? 0 : 1)
                        }
                    }
                    .onTapGesture {
                        hideKeyboard()
                        withAnimation{
                            onTap.toggle()
                            
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 0.1))
                    
                    if onTap {
                        Button(action: {
                            store.search = ""
                            hideKeyboard()
                                withAnimation{
                                    onTap.toggle()
                                }
                            
                        }, label: {
                                    Text("Отмена")
                                })
                    }
                }
                .padding([.top,.horizontal])
                
                if onTap {
                    List(store.searchItems.filter{$0.contains(store.search)}, id: \.self) { item in
                        
                        Text(item)
                    }
                }
                
                Spacer()
            }
            .frame(height: onTap ? CGFloat( screenHeight - 130) : 65)
            .background(onTap ? Color.white.ignoresSafeArea() : (Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0).ignoresSafeArea()))
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    func searchingInItems(){
        withAnimation(.linear){
            store.searchItems =  store.searchItems.filter{$0.lowercased().contains(store.search.lowercased())
            }
        }
    }
}


