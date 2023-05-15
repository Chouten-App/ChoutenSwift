//
//  ModuleSelector.swift
//  ModularSaikouS
//
//  Created by Inumaki on 18.03.23.
//

import SwiftUI
import Combine
import UIKit


/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}

struct AnimatedStroke: Shape {
    var lineWidth: CGFloat = 1
    var lineDash: [CGFloat] = [7]
    var animatableData: [CGFloat] {
        get { lineDash }
        set { lineDash = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        RoundedRectangle(cornerRadius: 12)
            .path(in: rect)
            .strokedPath(.init(lineWidth: lineWidth, dash: lineDash))
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

struct ModuleSelector: View, KeyboardReadable {
    @Binding var showPopup: Bool
    @StateObject var Colors = DynamicColors.shared
    
    let buttonHeight: CGFloat = 55
    @StateObject var globalData = GlobalData.shared
    @StateObject var moduleManager = ModuleManager.shared
    
    @State var availableModules: [OLDModule] = []
    @State var availableJsons: [URL] = []
    
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool
    @FocusState private var isNameFocused: Bool
    @State var isModule: Bool = true
    
    @State var importPressed = false
    @State var fileUrl: String = ""
    @State var fileName: String = ""
    
    @State private var isKeyboardVisible = false
    
    func loadData(module: Module)  {
        globalData.newModule = module
        globalData.reloadPlease = true
        let index = moduleManager.moduleIds.firstIndex(of: module.id)
        if index != nil {
            moduleManager.selectedModuleName = moduleManager.moduleFolderNames[index!]
        }
        if userInfo.count > 0 {
            userInfo[0].selectedModuleId = module.id
            try! moc.save()
        } else {
            let info = UserInfo(context: moc)
            info.selectedModuleId = module.id
            try! moc.save()
        }
    }
    
    @State var dash: [CGFloat] = [7]
    
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
            
            VStack {
                VStack {
                    if !importPressed {
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
                                Text("Import \(isModule ? "Module" : "Theme")")
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
                                    Text("Import \(isModule ? "Module" : "Theme") from URL")
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
                        .onTapGesture {
                            importPressed = true
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                ZStack {
                                    Image(systemName: "arrow.down")
                                        .font(.system(size: 16, weight: .heavy))
                                        .padding(.trailing, 6)
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
                                    Text("Import \(isModule ? "Module" : "Theme")")
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
                                        .font(.system(size: 20, weight: .bold))
                                        .lineLimit(1)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 20)
                            .onTapGesture {
                                importPressed = false
                            }
                            
                            Text("Import \(isModule ? "Module" : "Theme") or a Repo from a URL. Please make sure you trust the URL.")
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
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, 20)
                            
                            // Segemented Button
                            HStack {
                                HStack(spacing: 8) {
                                    Spacer()
                                    if isModule {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 14))
                                    }
                                    Text("Module")
                                        .font(.system(size: 14))
                                    Spacer()
                                }
                                .foregroundColor(
                                    isModule ? Color(hex:
                                                        globalData.appearance == .system
                                                     ? (
                                                        colorScheme == .dark
                                                        ? Colors.onSecondaryContainer.dark
                                                        : Colors.onSecondaryContainer.light
                                                     ) : (
                                                        globalData.appearance == .dark
                                                        ? Colors.onSecondaryContainer.dark
                                                        : Colors.onSecondaryContainer.light
                                                     )
                                    ) : Color(hex:
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
                                    )
                                )
                                .frame(height: 40)
                                .background {
                                    isModule ? Color(hex:
                                                        globalData.appearance == .system
                                                     ? (
                                                        colorScheme == .dark
                                                        ? Colors.SecondaryContainer.dark
                                                        : Colors.SecondaryContainer.light
                                                     ) : (
                                                        globalData.appearance == .dark
                                                        ? Colors.SecondaryContainer.dark
                                                        : Colors.SecondaryContainer.light
                                                     )
                                    ) : Color(hex:
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
                                .overlay(alignment: .trailing) {
                                    Rectangle()
                                        .fill(Color(hex:
                                                        globalData.appearance == .system
                                                     ? (
                                                        colorScheme == .dark
                                                        ? Colors.Outline.dark
                                                        : Colors.Outline.light
                                                     ) : (
                                                        globalData.appearance == .dark
                                                        ? Colors.Outline.dark
                                                        : Colors.Outline.light
                                                     )
                                    ))
                                        .frame(width: 1, height: 40)
                                }
                                .onTapGesture {
                                    isModule = true
                                }
                                
                                HStack(spacing: 8) {
                                    Spacer()
                                    if !isModule {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 14))
                                    }
                                    Text("Theme")
                                        .font(.system(size: 14))
                                    Spacer()
                                }
                                .foregroundColor(
                                    !isModule ? Color(hex:
                                                        globalData.appearance == .system
                                                     ? (
                                                        colorScheme == .dark
                                                        ? Colors.onSecondaryContainer.dark
                                                        : Colors.onSecondaryContainer.light
                                                     ) : (
                                                        globalData.appearance == .dark
                                                        ? Colors.onSecondaryContainer.dark
                                                        : Colors.onSecondaryContainer.light
                                                     )
                                    ) : Color(hex:
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
                                    )
                                )
                                .frame(height: 40)
                                .background {
                                    !isModule ? Color(hex:
                                                        globalData.appearance == .system
                                                     ? (
                                                        colorScheme == .dark
                                                        ? Colors.SecondaryContainer.dark
                                                        : Colors.SecondaryContainer.light
                                                     ) : (
                                                        globalData.appearance == .dark
                                                        ? Colors.SecondaryContainer.dark
                                                        : Colors.SecondaryContainer.light
                                                     )
                                    ) : Color(hex:
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
                                .overlay(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color(hex:
                                                        globalData.appearance == .system
                                                     ? (
                                                        colorScheme == .dark
                                                        ? Colors.Outline.dark
                                                        : Colors.Outline.light
                                                     ) : (
                                                        globalData.appearance == .dark
                                                        ? Colors.Outline.dark
                                                        : Colors.Outline.light
                                                     )
                                    ))
                                        .frame(width: 1, height: 40)
                                }
                                .onTapGesture {
                                    isModule = false
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                            .cornerRadius(40)
                            .overlay {
                                Capsule()
                                    .stroke(Color(hex:
                                                    globalData.appearance == .system
                                                   ? (
                                                    colorScheme == .dark
                                                    ? Colors.Outline.dark
                                                    : Colors.Outline.light
                                                   ) : (
                                                    globalData.appearance == .dark
                                                    ? Colors.Outline.dark
                                                    : Colors.Outline.light
                                                   )
                                                 ), lineWidth: 1)
                            }
                            .padding(.bottom, 20)
                            
                            TextField("", text: $fileUrl)
                                .disableAutocorrection(true)
                                .focused($isFocused)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(lineWidth: 1)
                                        .fill(isFocused ? Color(hex:
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
                                                               ) : Color(hex:
                                                                            globalData.appearance == .system
                                                                         ? (
                                                                            colorScheme == .dark
                                                                            ? Colors.Outline.dark
                                                                            : Colors.Outline.light
                                                                         ) : (
                                                                            globalData.appearance == .dark
                                                                            ? Colors.Outline.dark
                                                                            : Colors.Outline.light
                                                                         )
                                                                        )
                                        )
                                }
                                .overlay(alignment: .leading) {
                                    Text("Import from URL")
                                        .padding(.horizontal, isFocused ? 4 : 0)
                                        .foregroundColor(
                                            isFocused ? Color(hex:
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
                                                             ) : Color(hex:
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
                                                                      )
                                        )
                                        .font(isFocused ? .caption : .subheadline)
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
                                        .offset(y: isFocused ? -22 : 0)
                                        .padding(.horizontal, 16)
                                        .onTapGesture {
                                            isFocused = true
                                        }
                                        .animation(.easeInOut, value: isFocused)
                                }
                                .padding(.bottom, 20)
                            
                            HStack {
                                TextField("\(!fileUrl.isEmpty ? (URL(string: fileUrl)?.lastPathComponent ?? "") : "")", text: $fileName)
                                    .disableAutocorrection(true)
                                    .focused($isNameFocused)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(lineWidth: 1)
                                            .fill(isNameFocused ? Color(hex:
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
                                                                       ) : Color(hex:
                                                                                    globalData.appearance == .system
                                                                                 ? (
                                                                                    colorScheme == .dark
                                                                                    ? Colors.Outline.dark
                                                                                    : Colors.Outline.light
                                                                                 ) : (
                                                                                    globalData.appearance == .dark
                                                                                    ? Colors.Outline.dark
                                                                                    : Colors.Outline.light
                                                                                 )
                                                                                )
                                            )
                                    }
                                    .overlay(alignment: .leading) {
                                        Text("Filename")
                                            .padding(.horizontal, isNameFocused ? 4 : 0)
                                            .foregroundColor(
                                                isNameFocused ? Color(hex:
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
                                                                     ) : Color(hex:
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
                                                                              )
                                            )
                                            .font(isNameFocused ? .caption : .subheadline)
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
                                            .offset(y: isNameFocused ? -22 : 0)
                                            .padding(.horizontal, 16)
                                            .onTapGesture {
                                                isNameFocused = true
                                            }
                                            .animation(.easeInOut, value: isNameFocused)
                                    }
                                
                            }
                            .padding(.bottom, 24)
                            
                            HStack {
                                Spacer()
                                
                                Text("Cancel")
                                    .font(.system(size: 14))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
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
                                    .background {
                                        Capsule()
                                            .fill(.clear)
                                    }
                                    .onTapGesture {
                                        importPressed = false
                                    }
                                
                                Button {
                                    if fileUrl.isValidURL {
                                        guard let url = URL(string: fileUrl) else { return }
                                        let downloadTask = URLSession.shared.downloadTask(with: url) { (tempLocation, response, error) in
                                            guard let tempLocation = tempLocation, error == nil else {
                                                print("Error downloading file: \(error!.localizedDescription)")
                                                return
                                            }
                                            do {
                                                let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                                                
                                                var name: String = ""
                                                
                                                if !fileName.isEmpty {
                                                    name = fileName + ".module"
                                                } else {
                                                    let temp = url.lastPathComponent
                                                    if temp.contains(".module") {
                                                        name = temp
                                                    } else {
                                                        let filePrefix = "module_"
                                                        var highestNumber = 0
                                                        var highestFilename = "\(filePrefix)1.module" // default value if no files exist

                                                        do {
                                                            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
                                                            for fileURL in fileURLs {
                                                                let filename = fileURL.lastPathComponent
                                                                if filename.hasPrefix(filePrefix), let number = Int(filename.replacingOccurrences(of: filePrefix, with: "").replacingOccurrences(of: ".module", with: "")) {
                                                                    highestNumber = max(highestNumber, number)
                                                                }
                                                            }
                                                            if highestNumber > 0 {
                                                                highestFilename = "\(filePrefix)\(highestNumber).module"
                                                            }
                                                        } catch {
                                                            print("Error while enumerating files in documents directory: \(error.localizedDescription)")
                                                        }
                                                    }
                                                }
                                                
                                                let fileURL = documentsDirectory.appendingPathComponent("Modules").appendingPathComponent("\(name)")
                                                try FileManager.default.moveItem(at: tempLocation, to: fileURL)
                                                ModuleManager.shared.importFromFile(fileUrl: fileURL)
                                            } catch {
                                                print("Error moving file to documents directory: \(error.localizedDescription)")
                                            }
                                        }
                                        downloadTask.resume()
                                    }
                                } label: {
                                    Text("Import")
                                        .font(.system(size: 14, weight: .semibold))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
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
                                        .background {
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
                        }
                        .padding(.horizontal, 20)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    }
                }
                .background(.clear)
                .cornerRadius(12)
                .frame(height: importPressed ? 354 : buttonHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style:
                                    StrokeStyle(lineWidth: 1, dash: dash)
                               )
                    
                )
                .animation(.easeInOut, value: importPressed)
                
                ForEach(Array(zip(globalData.availableModules.indices, globalData.availableModules)), id: \.0) { index, module in
                    ButtonLarge(Colors: Colors, label: module.name, image: module.icon, developer: module.general.author,version: module.version, isSelected: globalData.newModule == module, background: Color(hex: module.general.bgColor), textColor: Color(hex: module.general.fgColor), action: {
                        // Action will be here
                        loadData(module: module)
                        showPopup = false
                    })
                    .frame(minHeight: buttonHeight)
                }
            }
            .padding(.bottom, 15)
            
            Divider()
                .foregroundColor(
                    Color(hex:
                            globalData.appearance == .system
                          ? (
                            colorScheme == .dark
                            ? Colors.OutlineVariant.dark
                            : Colors.OutlineVariant.light
                          ) : (
                            globalData.appearance == .dark
                            ? Colors.OutlineVariant.dark
                            : Colors.OutlineVariant.light
                          )
                         )
                )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, isKeyboardVisible ? 300 : 20)
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
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            isKeyboardVisible = newIsKeyboardVisible
        }
    }
}

struct ModuleSelector_Previews: PreviewProvider {
    static var previews: some View {
        ModuleSelector(showPopup: .constant(true))
    }
}
