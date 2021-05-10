//
//  Store.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import SwiftUI

class Store: ObservableObject{
    @Published var search = ""
    @Published var selectedItem = Item(name: "Американо", price: 110, quantity: nil, description: nil, image: "coffee1")
    @Published var popularsItems: [Item] = []
    @Published var currentItems: [Item] = []
    @Published var categories = ["Кофе", "Пончики"]
    @Published var currentCategory = "Кофе"
    
    @Published var showItemDetail = false
    
    func getItems(named: String){
        if named == "Кофе" {
            currentItems = coffee
        }
         
        if named == "Пончики" {
            currentItems = donuts
        }
      
       popularsItems = donuts
      
    }
 
}


let coffee = [
    Item(name: "Американо", price: 110, quantity: nil, description: nil, image: "coffee1"),
    Item(name: "Фильтр кофе", price: 110, quantity: nil, description: nil, image: "coffee2"),
    Item(name: "Капучино", price: 170, quantity: nil, description: nil, image: "coffee3"),
    Item(name: "Латте", price: 170, quantity: nil, description: nil, image: "coffee4"),
    Item(name: "Флэт Уайт", price: 160, quantity: nil, description: nil, image: "coffee5"),
    Item(name: "Раф", price: 205, quantity: nil, description: nil, image: "coffee6"),
    Item(name: "Айс-кофе", price: 185, quantity: nil, description: nil, image: "coffee7"),
]

let donuts = [
    Item(name: "Рафаэлло", price: 110, quantity: nil, description: nil, image: "donut1"),
    Item(name: "Ring", price: 110, quantity: nil, description: nil, image: "donut2"),
    Item(name: "Шелл Сливочный шоколад", price: 170, quantity: nil, description: nil, image: "donut3"),
    Item(name: "Шелл Сливочная вишня", price: 170, quantity: nil, description: nil, image: "donut4"),
    Item(name: "DoNuts", price: 160, quantity: nil, description: nil, image: "donut5"),
    Item(name: "ChocoDay", price: 205, quantity: nil, description: nil, image: "donut6"),
    Item(name: "Malinka", price: 185, quantity: nil, description: nil, image: "donut7"),
]
