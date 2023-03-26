//
//  Home.swift
//  ModularSaikouS
//
//  Created by Inumaki on 24.03.23.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            Search()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
