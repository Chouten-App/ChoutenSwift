//
//  ModuleSelector.swift
//  ModularSaikouS
//
//  Created by Inumaki on 18.03.23.
//

import SwiftUI

struct ModuleSelector: View{
    @Binding var showPopup: Bool
    @StateObject var Colors: DynamicColors
    
    let buttonHeight: CGFloat = 55
    @StateObject var globalData = GlobalData.shared
    
    @State var availableModules: [Module] = []
    @State var availableJsons: [URL] = []
    
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.colorScheme) var colorScheme
    
    func loadData(module: Module)  {
        print("loading data")
        globalData.module = module
        globalData.reloadPlease = true
        print(module.id)
        if userInfo.count > 0 {
            print("updating")
            userInfo[0].selectedModuleId = module.id
            try! moc.save()
        } else {
            print("adding")
            let info = UserInfo(context: moc)
            info.selectedModuleId = module.id
            try! moc.save()
        }
    }
    
    var body: some View{
        VStack(alignment: .center) {
            HStack {
                Text("Module Selector")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex:
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
                                          ))
                
            }
            .padding(.top, 40)
            .padding(.bottom, 4)
            
            Text("Select one of the modules below to provide this app with data:")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex:
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
                                      ).opacity(0.7))
                .padding(.bottom, 24)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showPopup = true
            }, label: {
                HStack {
                    ZStack {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 16, weight: .heavy))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 14)
                            .foregroundColor(Color(hex:
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
                                                  ))
                    }
                    .fixedSize()
                    .cornerRadius(40)
                    
                    VStack(alignment: .leading) {
                        Text("Import Module")
                            .foregroundColor(Color(hex:
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
                                                  ))
                            .font(.system(size: 16, weight: .bold))
                            .lineLimit(1)
                        
                        HStack {
                            Text("Import Module from URL")
                                .foregroundColor(Color(hex:
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
                                                      ).opacity(0.7))
                                .font(.system(size: 12, weight: .semibold))
                                .lineLimit(1)
                            
                        }
                    }
                    .frame(minHeight: 120)
                }
                .padding(.leading, 20)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            })
            .background(.clear)
            .cornerRadius(12)
            .frame(height: buttonHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [7]))
            )
            
            ForEach(Array(zip(globalData.availableModules.indices, globalData.availableModules)), id: \.0) { index, module in
                ButtonLarge(fileurl: globalData.availableJsons[index], label: module.name, image: module.metadata.icon, developer: module.metadata.author,version: module.version, background: Color(hex: module.metadata.bgColor), textColor: Color(hex: module.metadata.fgColor), action: {
                    // Action will be here
                    loadData(module: module)
                    showPopup = false
                })
                .frame(height: buttonHeight)
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
#if os(iOS)
        .frame(maxWidth: .infinity)
#elseif os(macOS)
        .frame(maxWidth: 400, maxHeight: .infinity, alignment: .top)
        .padding(.leading, 20)
#endif
        .foregroundColor(Color(hex:
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
                              ))
        .background {
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
        }
    }
}

struct ModuleSelector_Previews: PreviewProvider {
    static var previews: some View {
        ModuleSelector(showPopup: .constant(true), Colors: DynamicColors())
    }
}
