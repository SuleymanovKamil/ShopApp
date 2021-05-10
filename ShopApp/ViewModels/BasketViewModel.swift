//
//  BasketViewModel.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 10.05.2021.
//

import SwiftUI
import Combine

class BasketViewModel: ObservableObject {
    @Published var basket: [BasketItem] = [BasketItem(item: Item(name: "Американо", price: 110, quantity: nil, description: nil, image: "coffee1"), quantity: 2)
    ]
  
    var totalSum: Int {
        var sum = 0
        for i in basket {
            sum += i.quantity * i.item.price
        }
        return sum
    }
}
