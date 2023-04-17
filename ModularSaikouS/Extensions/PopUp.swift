//
//  PopUp.swift
//  Saikou Beta
//
//  Created by Inumaki on 20.02.23.
//

import SwiftUI
import UIKit

extension View {
    
    public func popup<PopupContent: View>(
        isPresented: Binding<Bool>,
        isHorizontal: Bool,
        view: @escaping () -> PopupContent) -> some View {
            self.modifier(
                Popup(
                    isPresented: isPresented,
                    isHorizontal: isHorizontal,
                    view: view)
            )
        }
}

public struct Popup<PopupContent>: ViewModifier where PopupContent: View {
    
    init(isPresented: Binding<Bool>,isHorizontal: Bool,
         view: @escaping () -> PopupContent) {
        self._isPresented = isPresented
        self.isHorizontal = isHorizontal
        self.view = view
    }
    
    /// Controls if the sheet should be presented or not
    @Binding var isPresented: Bool
    var isHorizontal: Bool
    
    /// The content to present
    var view: () -> PopupContent
    
    // MARK: - Private Properties
    /// The rect of the hosting controller
    @State private var presenterContentRect: CGRect = .zero
    
    /// The rect of popup content
    @State private var sheetContentRect: CGRect = .zero
    
    /// The offset when the popup is displayed
    private var displayedOffset: CGFloat {
        if (!isHorizontal) {
            return screenHeight - presenterContentRect.midY - 168
        } else {
            return screenWidth - presenterContentRect.width + (presenterContentRect.width / 1.65)
        }
    }
    
    /// The offset when the popup is hidden
    private var hiddenOffset: CGFloat {
        if presenterContentRect.isEmpty {
            return 1000
        }
        if(!isHorizontal) {
            return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 5
        } else {
            return presenterContentRect.width
        }
    }
    
    /// The current offset, based on the "presented" property
    private var currentOffset: CGFloat {
        return isPresented ? displayedOffset : hiddenOffset
    }
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    // MARK: - Content Builders
    public func body(content: Content) -> some View {
        ZStack {
            content
                .frameGetter($presenterContentRect)
        }
        .overlay(sheet())
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded({ value in
                                if isHorizontal && value.translation.width > 0 {
                                    dismiss()
                                }
                                if !isHorizontal && value.translation.height > 0 {
                                    dismiss()
                                }
                            }))
    }
    
    func sheet() -> some View {
        ZStack {
            self.view()
                .frameGetter($sheetContentRect)
                .frame(width: isHorizontal ? nil : screenWidth, height: isHorizontal ? screenHeight : nil)
                .offset(x: isHorizontal ? currentOffset : 0, y: isHorizontal ? -(screenHeight / 2 - 50) : currentOffset)
                .animation(Animation.spring(response: 0.3), value: currentOffset)
        }
    }
    
    private func dismiss() {
        isPresented = false
    }
}

extension View {
    func frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(FrameGetter(frame: frame))
    }
}

struct FrameGetter: ViewModifier {
    
    @Binding var frame: CGRect
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> AnyView in
                    let rect = proxy.frame(in: .global)
                    // This avoids an infinite layout loop
                    if rect.integral != self.frame.integral {
                        DispatchQueue.main.async {
                            self.frame = rect
                        }
                    }
                    return AnyView(EmptyView())
                })
    }
}

