//
//  SharedAlert.swift
//  ModularSaikouS
//
//  Created by Inumaki on 26.04.23.
//

import SwiftUI

struct CheckBoxToggleStyle: ToggleStyle {
    @StateObject var Colors = DynamicColors.shared
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var globalData: GlobalData = GlobalData.shared
    
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
            ZStack {
                if configuration.isOn {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            Color(hex:
                                    globalData.appearance == .system
                                  ? (
                                    colorScheme == .dark
                                    ? Colors.Primary.dark
                                    : Colors.Primary.light
                                  ) : (
                                    globalData.appearance == .dark
                                    ? Colors.Primary.dark
                                    : Colors.Primary.light
                                  )
                                 )
                        )
                        .frame(maxWidth: 18, maxHeight: 18)
                        .animation(.spring(response: 0.3), value: configuration.isOn)
                } else {
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(
                            Color(hex:
                                    globalData.appearance == .system
                                  ? (
                                    colorScheme == .dark
                                    ? Colors.onSurfaceVariant.dark
                                    : Colors.onSurfaceVariant.light
                                  ) : (
                                    globalData.appearance == .dark
                                    ? Colors.onSurfaceVariant.dark
                                    : Colors.onSurfaceVariant.light
                                  )
                                 ), lineWidth: 2)
                        .frame(maxWidth: 18, maxHeight: 18)
                        .animation(.spring(response: 0.3), value: configuration.isOn)
                }
                
                Image(systemName: "checkmark")
                    .font(.system(size: 8), weight: .bold)
                    .foregroundColor(configuration.isOn ?
                                     Color(hex:
                                             globalData.appearance == .system
                                           ? (
                                             colorScheme == .dark
                                             ? Colors.onPrimary.dark
                                             : Colors.onPrimary.light
                                           ) : (
                                             globalData.appearance == .dark
                                             ? Colors.onPrimary.dark
                                             : Colors.onPrimary.light
                                           )
                                          ) : .clear)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
            
            configuration.label
                .font(.system(size: 12, weight: .bold))
                .opacity(0.5)
        }
 
    }
}

struct SharedAlert: View {
    @StateObject var Colors = DynamicColors.shared
    
    @State var dontShowAgain: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var globalData: GlobalData = GlobalData.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Privacy")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 6)
            
            Text("We are not Responsible for any Modules you install, and cannot guarantee their safety.\nPlease use your own judgment to figure out if a Module is safe.")
                .font(.subheadline)
                .opacity(0.7)
            
            HStack {
                Toggle("Don't show again", isOn: $dontShowAgain)
                    .toggleStyle(CheckBoxToggleStyle(Colors: Colors))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("I understand")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(8)
                        .foregroundColor(
                            Color(hex:
                                    globalData.appearance == .system
                                  ? (
                                    colorScheme == .dark
                                    ? Colors.onPrimary.dark
                                    : Colors.onPrimary.light
                                  ) : (
                                    globalData.appearance == .dark
                                    ? Colors.onPrimary.dark
                                    : Colors.onPrimary.light
                                  )
                                 )
                        )
                        .background{
                            Capsule()
                                .fill(
                                    Color(hex:
                                            globalData.appearance == .system
                                          ? (
                                            colorScheme == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          ) : (
                                            globalData.appearance == .dark
                                            ? Colors.Primary.dark
                                            : Colors.Primary.light
                                          )
                                         )
                                )
                        }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .foregroundColor(
            Color(hex:
                    globalData.appearance == .system
                  ? (
                    colorScheme == .dark
                    ? Colors.onPrimaryContainer.dark
                    : Colors.onPrimaryContainer.light
                  ) : (
                    globalData.appearance == .dark
                    ? Colors.onPrimaryContainer.dark
                    : Colors.onPrimaryContainer.light
                  )
                 )
        )
        .background(
            Color(hex:
                    globalData.appearance == .system
                  ? (
                    colorScheme == .dark
                    ? Colors.SurfaceContainer.dark
                    : Colors.SurfaceContainer.light
                  ) : (
                    globalData.appearance == .dark
                    ? Colors.SurfaceContainer.dark
                    : Colors.SurfaceContainer.light
                  )
                 )
        )
        .cornerRadius(12)
        .padding(20)
    }
}

struct SharedAlert_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SharedAlert()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: DynamicColors().Surface.dark))
        .preferredColorScheme(.dark)
    }
}
