//
//  LoadingScreen.swift
//  laZina
//
//  Created by Камиль  Сулейманов on 12.12.2020.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        
        ZStack{
            
            Color.black.opacity(0.2).ignoresSafeArea(.all, edges: .all)
            
            ProgressView()
                .padding(20)
                .background(Color.white)
                .cornerRadius(10)
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
