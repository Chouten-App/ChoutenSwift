//
//  CustomBottomSheet.swift
//  ModularSaikouS
//
//  Created by Inumaki on 18.03.23.
//

import SwiftUI

struct BottomSheet: View {
    @Binding var isShowing: Bool
    var content: AnyView
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    .transition(.move(edge: .bottom))
                    .background(
                        Color(uiColor: .white)
                    )
                    .cornerRadius(16, corners: [.topLeft, .topRight])
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.spring(response: 0.3), value: isShowing)
    }
}

struct CustomBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(isShowing: .constant(true), content: AnyView(ModuleSelector(globalData: GlobalData())))
    }
}
