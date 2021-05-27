//
//  Order.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 26.05.2021.
//

import Foundation

struct Order: Hashable {
    let date: String
    let item: [[String : Int]]
    let orderNumber: Int
    let totalSum: String
    let deliveryAddress: String
}
