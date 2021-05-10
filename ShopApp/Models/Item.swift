//
//  Item.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import Foundation

struct Item: Hashable{
    let name: String
    let price: Int
    let quantity: Int?
    let description: String?
    let image: String?
}


