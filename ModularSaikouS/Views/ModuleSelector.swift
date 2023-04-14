//
//  ModuleSelector.swift
//  ModularSaikouS
//
//  Created by Inumaki on 18.03.23.
//

import SwiftUI

struct ModuleSelector: View{
    @StateObject var globalData: GlobalData
    
    let buttonHeight: CGFloat = 55
    
    @State var availableModules: [Module] = []
    
    func loadData(module: Module)  {
        print("loading data")
        globalData.module = module
        globalData.reloadPlease = true
    }
    
    var body: some View{
        VStack(alignment: .center) {
            HStack {
                Text("Module Selector")
                    .font(.system(size: 20, weight: .bold))
                
            }
            .padding(.top, 40)
            .padding(.bottom, 4)
            
            Text("Select one of the modules below to provide this app with data:")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color("textColor2").opacity(0.7))
                .padding(.bottom, 24)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
            
            Button(action: {
                
            }, label: {
                HStack {
                    ZStack {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 16, weight: .heavy))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 14)
                            .foregroundColor(Color("textColor2"))
                    }
                    .fixedSize()
                    .cornerRadius(40)
                    
                    VStack(alignment: .leading) {
                        Text("Import Module")
                            .foregroundColor(Color("textColor2"))
                            .font(.system(size: 16, weight: .bold))
                            .lineLimit(1)
                        
                        HStack {
                            Text("Import Module from URL")
                                .foregroundColor(Color("textColor2").opacity(0.7))
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
            
            ForEach(availableModules, id: \.self) {module in
                ButtonLarge(label: module.name, image: module.metadata.icon, developer: module.metadata.author,version: module.version, background: Color(hex: module.metadata.bgColor ?? "#ff007e"), textColor: Color(hex: module.metadata.fgColor ?? "#ffffff"), action: {
                    // Action will be here
                    loadData(module: module)
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
        .foregroundColor(Color("textColor2"))
        .background {
            Color("bg")
        }
        .onAppear {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                do {
                    let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
                    let jsonFiles = directoryContents.filter { $0.pathExtension == "json" }
                    for fileURL in jsonFiles {
                        let fileData = try Data(contentsOf: fileURL)
                        print(fileData)
                        // Do something with the file data
                        do {
                            let decoded = try JSONDecoder().decode(Module.self, from: fileData)
                            print(decoded)
                            if decoded != nil {
                                availableModules.append(decoded)
                            }
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                } catch {
                    print("Error getting directory contents: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct ModuleSelector_Previews: PreviewProvider {
    static var previews: some View {
        ModuleSelector(globalData: GlobalData())
    }
}
