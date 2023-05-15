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
    var fromRight: Bool = false
    var fromLeft: Bool = false
    
    @State private var offsetY: Double = 0.0
    #if os(macOS)
    // Running on macOS through Catalyst
    let alignment = Alignment.trailing
    #else
    // Running on iOS
    let alignment = Alignment.bottom
    #endif
    
    var body: some View {
        GeometryReader { proxy in
            if fromLeft {
                ZStack(alignment: Alignment.leading) {
                    if (isShowing) {
                        Color.black
                            .opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                isShowing.toggle()
                            }
                            .gesture(DragGesture()
                                .onChanged({ val in
                                    if(val.translation.width <= 0) {
                                        offsetY = val.translation.width
                                    }
                                })
                                    .onEnded({ val in
                                        if val.translation.width < -200 {
                                            isShowing = false
                                        }
                                        offsetY = 0
                                    })
                            )
                        content
#if os(iOS)
                            .offset(x: offsetY)
                            .animation(.spring(response: 0.3), value: offsetY)
                            .transition(.move(edge: .leading))
#elseif os(macOS)
                            .offset(x: offsetY)
                            .animation(.spring(response: 0.3), value: offsetY)
                            .transition(.move(edge: .trailing))
#endif
                            .background(
                                Color(.clear)
                            )
#if os(iOS)
                            .overlay(alignment: .trailing) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color("Outline"))
                                        .frame(maxWidth: 4, maxHeight: 32)
                                        .offset(x: offsetY)
                                        .animation(.spring(response: 0.3), value: offsetY)
                                        .padding(.trailing, 16)
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .gesture(DragGesture()
                                    .onChanged({ val in
                                        if(val.translation.width <= 0) {
                                            offsetY = val.translation.width
                                        }
                                    })
                                        .onEnded({ val in
                                            if val.translation.width < -200 {
                                                isShowing = false
                                            }
                                            offsetY = 0
                                        })
                                )
                            }
                            .cornerRadius(20, corners: [.bottomRight, .topRight])
#elseif os(macOS)
                            .overlay(alignment: .leading) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color("Outline"))
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
            } else {
                ZStack(alignment: fromRight ? Alignment.trailing : alignment) {
                    if (isShowing) {
                        Color.black
                            .opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                isShowing.toggle()
                            }
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
                        content
#if os(iOS)
                            .offset(x: fromRight ? offsetY : 0,y: fromRight ? 0 : offsetY)
                            .animation(.spring(response: 0.3), value: offsetY)
                            .transition(.move(edge: fromRight ? .trailing : .bottom))
#elseif os(macOS)
                            .offset(x: offsetY)
                            .animation(.spring(response: 0.3), value: offsetY)
                            .transition(.move(edge: .trailing))
#endif
                            .background(
                                Color(.clear)
                            )
#if os(iOS)
                            .overlay(alignment: fromRight ? .leading : .top) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color("Outline"))
                                        .frame(maxWidth: fromRight ? 4 : 32, maxHeight: fromRight ? 32 : 4)
                                        .offset(x: fromRight ? offsetY : 0,y: fromRight ? 0 : offsetY)
                                        .animation(.spring(response: 0.3), value: offsetY)
                                        .padding(.top, fromRight ? 0 : 16)
                                        .padding(.leading, fromRight ? 16 : 0)
                                }
                                .frame(maxWidth: fromRight ? nil : .infinity, maxHeight: fromRight ? .infinity : nil)
                                .contentShape(Rectangle())
                                .gesture(DragGesture()
                                    .onChanged({ val in
                                        if (fromRight ? val.translation.width : val.translation.height) >= 0 {
                                            offsetY = fromRight ? val.translation.width : val.translation.height
                                        }
                                    })
                                        .onEnded({ val in
                                            if (fromRight ? val.translation.width : val.translation.height) > 200 {
                                                isShowing = false
                                            }
                                            offsetY = 0
                                        })
                                )
                            }
                            .cornerRadius(20, corners: fromRight ? [.topLeft, .bottomLeft] : [.topLeft, .topRight])
#elseif os(macOS)
                            .overlay(alignment: .leading) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color("Outline"))
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
}

struct CustomBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(isShowing: .constant(true), content: AnyView(ModuleSelector(showPopup: .constant(true))))
    }
}
