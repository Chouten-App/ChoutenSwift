//
//  SettingsView.swift
//  ModularSaikouS
//
//  Created by Inumaki on 26.04.23.
//

import SwiftUI

struct AppearanceSelector: View {
    @StateObject var Colors: DynamicColors
    @Binding var showSelector: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var selectedOption: Int = 0
    
    @StateObject var globalData = GlobalData.shared
    
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Appearance")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(
                                selectedOption == 0 ?
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
                                     ) :
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
                                         ),
                                lineWidth: 2
                            )
                            .frame(width: 20)
                        
                        if selectedOption == 0 {
                            Circle()
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
                                .frame(width: 12)
                        }
                    }
                    Text("Light")
                    
                    Spacer()
                }
                .onTapGesture {
                    selectedOption = 0
                    globalData.appearance = .light
                    
                    if userInfo.count > 0 {
                        print("updating")
                        do {
                            userInfo[0].selectedAppearance = 0
                            try moc.save()
                        } catch let error {
                            print(error)
                        }
                    } else {
                        print("adding")
                        do {
                            let info = UserInfo(context: moc)
                            info.selectedAppearance = 0
                            try moc.save()
                        } catch let error {
                            print(error)
                        }
                    }
                }
                
                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(
                                selectedOption == 1 ?
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
                                     ) :
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
                                         ),
                                lineWidth: 2
                            )
                            .frame(width: 20)
                        
                        if selectedOption == 1 {
                            Circle()
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
                                .frame(width: 12)
                        }
                    }
                    Text("Dark")
                    
                    Spacer()
                }
                .onTapGesture {
                    selectedOption = 1
                    globalData.appearance = .dark
                    
                    if userInfo.count > 0 {
                        print("updating")
                        do {
                            userInfo[0].selectedAppearance = 1
                            try moc.save()
                        } catch let error {
                            print(error)
                        }
                    } else {
                        print("adding")
                        do {
                            let info = UserInfo(context: moc)
                            info.selectedAppearance = 1
                            try moc.save()
                        } catch let error {
                            print(error)
                        }
                    }
                }
                
                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(
                                selectedOption == 2 ?
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
                                     ) :
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
                                         ),
                                lineWidth: 2
                            )
                            .frame(width: 20)
                        
                        if selectedOption == 2 {
                            Circle()
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
                                .frame(width: 12)
                        }
                    }
                    Text("System")
                    
                    Spacer()
                }
                .onTapGesture {
                    selectedOption = 2
                    globalData.appearance = .system
                    
                    if userInfo.count > 0 {
                        print("updating")
                        do {
                            userInfo[0].selectedAppearance = 2
                            try moc.save()
                        } catch let error {
                            print(error)
                        }
                    } else {
                        print("adding")
                        do {
                            let info = UserInfo(context: moc)
                            info.selectedAppearance = 2
                            try moc.save()
                        } catch let error {
                            print(error)
                        }
                    }
                }
            }
            
            HStack {
                Spacer()
                
                Button {
                    showSelector = false
                } label: {
                    Text("Confirm")
                        .foregroundColor(
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
        .padding(16)
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
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(
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
        }
        .onAppear {
            if globalData.appearance == .light {
                selectedOption = 0
            } else if globalData.appearance == .dark {
                selectedOption = 1
            } else {
                selectedOption = 2
            }
        }
    }
}

struct SettingsView: View {
    @StateObject var Colors: DynamicColors
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var showAppearanceSelector: Bool = false
    @StateObject var globalData = GlobalData.shared
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Settings")
                    .font(.title)
                    .fontWeight(.semibold)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Export Theme to JSON")
                            .fontWeight(.semibold)
                        Text("Copy your theme in JSON format")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .opacity(0.7)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
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
                            .opacity(0.7)
                            .frame(maxWidth: 14, maxHeight: 18)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(
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
                                         ),lineWidth: 2)
                            .frame(maxWidth: 14, maxHeight: 18)
                            .offset(x: 4, y: -4)
                    }
                }
                .onTapGesture {
                    let json = Colors.getAsJson()
                    
                    print(json)
                    
                    UIPasteboard.general.setValue(json, forPasteboardType: "public.json")
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Appearance")
                            .fontWeight(.semibold)
                        Text("Light/Dark/System")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .opacity(0.7)
                    }
                    
                    Spacer()
                }
                .onTapGesture {
                    showAppearanceSelector = true
                }
                
                NavigationLink(destination: Appearance(Colors: Colors)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Theme")
                                .fontWeight(.semibold)
                            Text("Change the Colors of the app.")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.7)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                }
                Button {
                    Colors.storeToJson()
                } label: {
                    Text("Save Theme to JSON.")
                        .fontWeight(.bold)
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
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background {
                            
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
                                .cornerRadius(12)
                        }
                }
                
                Spacer()
                
                NavigationLink(destination: Developer(Colors: Colors)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Developer")
                                .fontWeight(.semibold)
                            Text("Only Dev Stuff. Dont Touch!")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .opacity(0.7)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                }
                
                HStack(spacing: 12) {
                    Image("coffee")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .onTapGesture {
                            if let url = URL(string: "https://www.buymeacoffee.com/inumaki") {
                                UIApplication.shared.open(url)
                            }
                        }
                    
                    Image("ko-fi")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .onTapGesture {
                            if let url = URL(string: "https://ko-fi.com/inumakicoding") {
                                UIApplication.shared.open(url)
                            }
                        }
                }
                .padding(.bottom, 120)
            }
            .padding(.horizontal, 20)
            .padding(.top, 80)
            .foregroundColor(
                Color(hex:
                            globalData.appearance == .system
                          ? (
                            colorScheme == .dark
                            ? Colors.onSurface.dark
                            : Colors.onSurface.light
                          ) : (
                            globalData.appearance == .dark
                            ? Colors.onSurface.dark
                            : Colors.onSurface.light
                          )
                         ))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background {
                Color(hex:
                            globalData.appearance == .system
                          ? (
                            colorScheme == .dark
                            ? Colors.Surface.dark
                            : Colors.Surface.light
                          ) : (
                            globalData.appearance == .dark
                            ? Colors.Surface.dark
                            : Colors.Surface.light
                          )
                         )
            }
            .overlay {
                if showAppearanceSelector {
                    ZStack {
                        Color.black.opacity(0.4)
                        
                        AppearanceSelector(Colors: Colors, showSelector: $showAppearanceSelector)
                            .frame(width: 240)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(Colors: DynamicColors())
    }
}
