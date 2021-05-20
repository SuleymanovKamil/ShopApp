//
//  user.swift
//  laZina
//
//  Created by Камиль Сулейманов on 15.02.2021.
//

import Foundation

struct User: Identifiable {
    let id: String?
    let userName: String
    var location: String?
    let token: String?
}
