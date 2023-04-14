//
//  Loading.swift
//  Saikou Beta
//
//  Created by Inumaki on 20.02.23.
//

import SwiftUI

struct Loading: View {
    var body: some View {
        ZStack {
            ProgressView()
        }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
