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
    
    @State private var offsetY: Double = 0.0
    #if os(macOS)
    // Running on macOS through Catalyst
    let alignment = Alignment.trailing
    #else
    // Running on iOS
    let alignment = Alignment.bottom
    #endif
    
    var body: some View {
        
        ZStack(alignment: alignment) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    #if os(iOS)
                    .offset(y: offsetY)
                    .animation(.spring(response: 0.3), value: offsetY)
                    .transition(.move(edge: .bottom))
                    #elseif os(macOS)
                    .offset(x: offsetY)
                    .animation(.spring(response: 0.3), value: offsetY)
                    .transition(.move(edge: .trailing))
                    #endif
                    .background(
                        Color(.clear)
                    )
                    #if os(iOS)
                    .overlay(alignment: .top) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("accentColor1"))
                                .frame(maxWidth: 40, maxHeight: 4)
                                .offset(y: offsetY)
                                .animation(.spring(response: 0.3), value: offsetY)
                                .padding(.top, 16)
                        }
                        .frame(maxWidth: .infinity)
                        .gesture(DragGesture()
                            .onChanged({ val in
                                if(val.translation.height >= 0) {
                                    offsetY = val.translation.height
                                }
                            })
                            .onEnded({ val in
                                if val.translation.height > 200 {
                                    isShowing = false
                                }
                                offsetY = 0
                            })
                        )
                    }
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    #elseif os(macOS)
                    .overlay(alignment: .leading) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("accentColor1"))
                                .frame(maxWidth: 4, maxHeight: 40)
                                .offset(x: offsetY)
                                .animation(.spring(response: 0.3), value: offsetY)
                                .padding(.leading, 16)
                        }
                        .frame(maxHeight: .infinity)
                        .gesture(DragGesture()
                            .onChanged({ val in
                                if(val.translation.width >= 0) {
                                    offsetY = val.translation.width
                                }
                            })
                            .onEnded({ val in
                                if val.translation.width > 200 {
                                    isShowing = false
                                }
                                offsetY = 0
                            })
                        )
                    }
                    #endif
                    .clipped(antialiased: true)
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
