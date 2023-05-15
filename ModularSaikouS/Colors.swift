//
//  Colors.swift
//  ModularSaikouS
//
//  Created by Inumaki on 21.04.23.
//

import SwiftUI

struct CustomColor: Codable {
    var light: String
    var dark: String
}

struct JSONColors: Codable {
    let dark: SubColors
    let light: SubColors
}

struct SubColors: Codable {
    let Primary: String
    let onPrimary: String
    let PrimaryContainer: String
    let onPrimaryContainer: String
    let PrimaryFixed: String?
    let PrimaryFixedDim: String?
    let onPrimaryFixed: String?
    let onPrimaryFixedVariant: String?
    
    let Secondary: String
    let onSecondary: String
    let SecondaryContainer: String
    let onSecondaryContainer: String
    let SecondaryFixed: String?
    let SecondaryFixedDim: String?
    let onSecondaryFixed: String?
    let onSecondaryFixedVariant: String?
    
    let Tertiary: String
    let onTertiary: String
    let TertiaryContainer: String
    let onTertiaryContainer: String
    let TertiaryFixed: String?
    let TertiaryFixedDim: String?
    let onTertiaryFixed: String?
    let onTertiaryFixedVariant: String?
    
    let Error: String
    let ErrorContainer: String
    let onError: String
    let onErrorContainer: String
    
    let Surface: String
    let SurfaceDim: String?
    let SurfaceBright: String?
    
    let SurfaceContainerLowest: String?
    let SurfaceContainerLow: String?
    let SurfaceContainer: String
    let SurfaceContainerHigh: String?
    let SurfaceContainerHighest: String?
    
    let onSurface: String
    let onSurfaceVariant: String
    let Outline: String
    let OutlineVariant: String
    
    let InverseSurface: String
    let InverseOnSurface: String
    let InversePrimary: String
    let Scrim: String
    let Shadow: String?
}

class DynamicColors: ObservableObject {
    static let shared = DynamicColors()
    init(fileName: String = "default") {
        getFromJson(fileName: fileName)
    }
    // Primary
    @Published var Primary: CustomColor = CustomColor(light: "#005ac1", dark: "#adc6ff")
    @Published var onPrimary: CustomColor = CustomColor(light: "#ffffff", dark: "#002e69")
    @Published var PrimaryContainer: CustomColor = CustomColor(light: "#d8e2ff", dark: "#004494")
    @Published var onPrimaryContainer: CustomColor = CustomColor(light: "#001a41", dark: "#d8e2ff")
    
    @Published var PrimaryFixed: CustomColor? = CustomColor(light: "#d8e2ff", dark: "#d8e2ff")
    @Published var PrimaryFixedDim: CustomColor? = CustomColor(light: "#001a41", dark: "#adc6ff")
    @Published var onPrimaryFixed: CustomColor? = CustomColor(light: "#adc6ff", dark: "#001a41")
    @Published var onPrimaryFixedVariant: CustomColor? = CustomColor(light: "#004494", dark: "#004494")
    
    // Secondary
    @Published var Secondary: CustomColor = CustomColor(light: "#575e71", dark: "#bfc6dc")
    @Published var onSecondary: CustomColor = CustomColor(light: "#ffffff", dark: "#293041")
    @Published var SecondaryContainer: CustomColor = CustomColor(light: "#dbe2f9", dark: "#3f4759")
    @Published var onSecondaryContainer: CustomColor = CustomColor(light: "#141b2c", dark: "#dbe2f9")
    
    @Published var SecondaryFixed: CustomColor? = CustomColor(light: "#dbe2f9", dark: "#dbe2f9")
    @Published var SecondaryFixedDim: CustomColor? = CustomColor(light: "#bfc6dc", dark: "#bfc6dc")
    @Published var onSecondaryFixed: CustomColor? = CustomColor(light: "#141b2c", dark: "#141b2c")
    @Published var onSecondaryFixedVariant: CustomColor? = CustomColor(light: "#141b2c", dark: "#3f4759")
    
    // Tertiary
    @Published var Tertiary: CustomColor = CustomColor(light: "#715573", dark: "#debcdf")
    @Published var onTertiary: CustomColor = CustomColor(light: "#ffffff", dark: "#402843")
    @Published var TertiaryContainer: CustomColor = CustomColor(light: "#fbd7fc", dark: "#583e5b")
    @Published var onTertiaryContainer: CustomColor = CustomColor(light: "#29132d", dark: "#fbd7fc")
    
    @Published var TertiaryFixed: CustomColor? = CustomColor(light: "#fbd7fc", dark: "#fbd7fc")
    @Published var TertiaryFixedDim: CustomColor? = CustomColor(light: "#debcdf", dark: "#debcdf")
    @Published var onTertiaryFixed: CustomColor? = CustomColor(light: "#29132d", dark: "#29132d")
    @Published var onTertiaryFixedVariant: CustomColor? = CustomColor(light: "#583e5b", dark: "#583e5b")
    
    // Error
    @Published var Error: CustomColor = CustomColor(light: "#ba1a1a", dark: "#ffb4ab")
    @Published var ErrorContainer: CustomColor = CustomColor(light: "#ffdad6", dark: "#93000a")
    @Published var onError: CustomColor = CustomColor(light: "#ffffff", dark: "#690005")
    @Published var onErrorContainer: CustomColor = CustomColor(light: "#410002", dark: "#ffdad6")
    
    // Surface
    @Published var Surface: CustomColor = CustomColor(light: "#faf9fd", dark: "#121316")
    @Published var SurfaceDim: CustomColor? = CustomColor(light: "#dbd9dd", dark: "#121316")
    @Published var SurfaceBright: CustomColor? = CustomColor(light: "#faf9fd", dark: "#38393c")
    
    @Published var SurfaceContainerLowest: CustomColor? = CustomColor(light: "#ffffff", dark: "#0d0e11")
    @Published var SurfaceContainerLow: CustomColor? = CustomColor(light: "#f5f3f7", dark: "#1b1b1f")
    @Published var SurfaceContainer: CustomColor = CustomColor(light: "#efedf1", dark: "#1f1f23")
    @Published var SurfaceContainerHigh: CustomColor? = CustomColor(light: "#e9e7ec", dark: "#292a2d")
    @Published var SurfaceContainerHighest: CustomColor? = CustomColor(light: "#e3e2e6", dark: "#343538")
    
    @Published var onSurface: CustomColor = CustomColor(light: "#1b1b1f", dark: "#c7c6ca")
    @Published var onSurfaceVariant: CustomColor = CustomColor(light: "#e1e2ec", dark: "#c4c6d0")
    @Published var Outline: CustomColor = CustomColor(light: "#74777f", dark: "#8e9099")
    @Published var OutlineVariant: CustomColor = CustomColor(light: "#c4c6d0", dark: "#44474f")
    
    @Published var InverseSurface: CustomColor = CustomColor(light: "#303033", dark: "#e3e2e6")
    @Published var InverseOnSurface: CustomColor = CustomColor(light: "#f2f0f4", dark: "#1b1b1f")
    @Published var InversePrimary: CustomColor = CustomColor(light: "#adc6ff", dark: "#005ac1")
    @Published var Scrim: CustomColor = CustomColor(light: "#000000", dark: "#000000")
    @Published var Shadow: CustomColor? = CustomColor(light: "#000000", dark: "#000000")
    
    func getFromJson(fileName: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let themeURL = documentsURL.appendingPathComponent("Themes").appendingPathComponent("\(fileName).theme")
        
        do {
            let jsonData = try Data(contentsOf: themeURL)
            let decoder = JSONDecoder()
            let jsonColors = try decoder.decode(JSONColors.self, from: jsonData)
            
            Primary = CustomColor(light: jsonColors.light.Primary, dark: jsonColors.dark.Primary)
            onPrimary = CustomColor(light: jsonColors.light.onPrimary, dark: jsonColors.dark.onPrimary)
            PrimaryContainer = CustomColor(light: jsonColors.light.PrimaryContainer, dark: jsonColors.dark.PrimaryContainer)
            onPrimaryContainer = CustomColor(light: jsonColors.light.onPrimaryContainer, dark: jsonColors.dark.onPrimaryContainer)
            PrimaryFixed = CustomColor(light: jsonColors.light.PrimaryFixed ?? "", dark: jsonColors.dark.PrimaryFixed ?? "")
            PrimaryFixedDim = CustomColor(light: jsonColors.light.PrimaryFixedDim ?? "", dark: jsonColors.dark.PrimaryFixedDim ?? "")
            onPrimaryFixed = CustomColor(light: jsonColors.light.onPrimaryFixed ?? "", dark: jsonColors.dark.onPrimaryFixed ?? "")
            onPrimaryFixedVariant = CustomColor(light: jsonColors.light.onPrimaryFixedVariant ?? "", dark: jsonColors.dark.onPrimaryFixedVariant ?? "")
            
            Secondary = CustomColor(light: jsonColors.light.Secondary, dark: jsonColors.dark.Secondary)
            onSecondary = CustomColor(light: jsonColors.light.onSecondary, dark: jsonColors.dark.onSecondary)
            SecondaryContainer = CustomColor(light: jsonColors.light.SecondaryContainer, dark: jsonColors.dark.SecondaryContainer)
            onSecondaryContainer = CustomColor(light: jsonColors.light.onSecondaryContainer, dark: jsonColors.dark.onSecondaryContainer)
            SecondaryFixed = CustomColor(light: jsonColors.light.SecondaryFixed ?? "", dark: jsonColors.dark.SecondaryFixed ?? "")
            SecondaryFixedDim = CustomColor(light: jsonColors.light.SecondaryFixedDim ?? "", dark: jsonColors.dark.SecondaryFixedDim ?? "")
            onSecondaryFixed = CustomColor(light: jsonColors.light.onSecondaryFixed ?? "", dark: jsonColors.dark.onSecondaryFixed ?? "")
            onSecondaryFixedVariant = CustomColor(light: jsonColors.light.onSecondaryFixedVariant ?? "", dark: jsonColors.dark.onSecondaryFixedVariant ?? "")
            
            Tertiary = CustomColor(light: jsonColors.light.Tertiary, dark: jsonColors.dark.Tertiary)
            onTertiary = CustomColor(light: jsonColors.light.onTertiary, dark: jsonColors.dark.onTertiary)
            TertiaryContainer = CustomColor(light: jsonColors.light.TertiaryContainer, dark: jsonColors.dark.TertiaryContainer)
            onTertiaryContainer = CustomColor(light: jsonColors.light.onTertiaryContainer, dark: jsonColors.dark.onTertiaryContainer)
            TertiaryFixed = CustomColor(light: jsonColors.light.TertiaryFixed ?? "", dark: jsonColors.dark.TertiaryFixed ?? "")
            TertiaryFixedDim = CustomColor(light: jsonColors.light.TertiaryFixedDim ?? "", dark: jsonColors.dark.TertiaryFixedDim ?? "")
            onTertiaryFixed = CustomColor(light: jsonColors.light.onTertiaryFixed ?? "", dark: jsonColors.dark.onTertiaryFixed ?? "")
            onTertiaryFixedVariant = CustomColor(light: jsonColors.light.onTertiaryFixedVariant ?? "", dark: jsonColors.dark.onTertiaryFixedVariant ?? "")
            
            Error = CustomColor(light: jsonColors.light.Error, dark: jsonColors.dark.Error)
            ErrorContainer = CustomColor(light: jsonColors.light.ErrorContainer, dark: jsonColors.dark.ErrorContainer)
            onError = CustomColor(light: jsonColors.light.onError, dark: jsonColors.dark.onError)
            onErrorContainer = CustomColor(light: jsonColors.light.onErrorContainer, dark: jsonColors.dark.onErrorContainer)
            
            Surface = CustomColor(light: jsonColors.light.Surface, dark: jsonColors.dark.Surface)
            SurfaceDim = CustomColor(light: jsonColors.light.SurfaceDim ?? "", dark: jsonColors.dark.SurfaceDim ?? "")
            SurfaceBright = CustomColor(light: jsonColors.light.SurfaceBright ?? "", dark: jsonColors.dark.SurfaceBright ?? "")
            
            SurfaceContainerLowest = CustomColor(light: jsonColors.light.SurfaceContainerLowest ?? "", dark: jsonColors.dark.SurfaceContainerLowest ?? "")
            SurfaceContainerLow = CustomColor(light: jsonColors.light.SurfaceContainerLow ?? "", dark: jsonColors.dark.SurfaceContainerLow ?? "")
            SurfaceContainer = CustomColor(light: jsonColors.light.SurfaceContainer, dark: jsonColors.dark.SurfaceContainer)
            SurfaceContainerHigh = CustomColor(light: jsonColors.light.SurfaceContainerHigh ?? "", dark: jsonColors.dark.SurfaceContainerHigh ?? "")
            SurfaceContainerHighest = CustomColor(light: jsonColors.light.SurfaceContainerHighest ?? "", dark: jsonColors.dark.SurfaceContainerHighest ?? "")
            
            onSurface = CustomColor(light: jsonColors.light.onSurface, dark: jsonColors.dark.onSurface)
            onSurfaceVariant = CustomColor(light: jsonColors.light.onSurfaceVariant, dark: jsonColors.dark.onSurfaceVariant)
            Outline = CustomColor(light: jsonColors.light.Outline, dark: jsonColors.dark.Outline)
            OutlineVariant = CustomColor(light: jsonColors.light.OutlineVariant, dark: jsonColors.dark.OutlineVariant)
            InverseSurface = CustomColor(light: jsonColors.light.InverseSurface, dark: jsonColors.dark.InverseSurface)
            InverseOnSurface = CustomColor(light: jsonColors.light.InverseOnSurface, dark: jsonColors.dark.InverseOnSurface)
            InversePrimary = CustomColor(light: jsonColors.light.InversePrimary, dark: jsonColors.dark.InversePrimary)
            
            Scrim = CustomColor(light: jsonColors.light.Scrim, dark: jsonColors.dark.Scrim)
            Shadow = CustomColor(light: jsonColors.light.Shadow ?? "", dark: jsonColors.dark.Shadow ?? "")
            
            //return jsonColors
        } catch {
            print("Error reading theme JSON:", error.localizedDescription)
        }
    }
    
    func setFromModel(jsonColors: JSONColors) {
        Primary = CustomColor(light: jsonColors.light.Primary, dark: jsonColors.dark.Primary)
        onPrimary = CustomColor(light: jsonColors.light.onPrimary, dark: jsonColors.dark.onPrimary)
        PrimaryContainer = CustomColor(light: jsonColors.light.PrimaryContainer, dark: jsonColors.dark.PrimaryContainer)
        onPrimaryContainer = CustomColor(light: jsonColors.light.onPrimaryContainer, dark: jsonColors.dark.onPrimaryContainer)
        PrimaryFixed = CustomColor(light: jsonColors.light.PrimaryFixed ?? "", dark: jsonColors.dark.PrimaryFixed ?? "")
        PrimaryFixedDim = CustomColor(light: jsonColors.light.PrimaryFixedDim ?? "", dark: jsonColors.dark.PrimaryFixedDim ?? "")
        onPrimaryFixed = CustomColor(light: jsonColors.light.onPrimaryFixed ?? "", dark: jsonColors.dark.onPrimaryFixed ?? "")
        onPrimaryFixedVariant = CustomColor(light: jsonColors.light.onPrimaryFixedVariant ?? "", dark: jsonColors.dark.onPrimaryFixedVariant ?? "")
        
        Secondary = CustomColor(light: jsonColors.light.Secondary, dark: jsonColors.dark.Secondary)
        onSecondary = CustomColor(light: jsonColors.light.onSecondary, dark: jsonColors.dark.onSecondary)
        SecondaryContainer = CustomColor(light: jsonColors.light.SecondaryContainer, dark: jsonColors.dark.SecondaryContainer)
        onSecondaryContainer = CustomColor(light: jsonColors.light.onSecondaryContainer, dark: jsonColors.dark.onSecondaryContainer)
        SecondaryFixed = CustomColor(light: jsonColors.light.SecondaryFixed ?? "", dark: jsonColors.dark.SecondaryFixed ?? "")
        SecondaryFixedDim = CustomColor(light: jsonColors.light.SecondaryFixedDim ?? "", dark: jsonColors.dark.SecondaryFixedDim ?? "")
        onSecondaryFixed = CustomColor(light: jsonColors.light.onSecondaryFixed ?? "", dark: jsonColors.dark.onSecondaryFixed ?? "")
        onSecondaryFixedVariant = CustomColor(light: jsonColors.light.onSecondaryFixedVariant ?? "", dark: jsonColors.dark.onSecondaryFixedVariant ?? "")
        
        Tertiary = CustomColor(light: jsonColors.light.Tertiary, dark: jsonColors.dark.Tertiary)
        onTertiary = CustomColor(light: jsonColors.light.onTertiary, dark: jsonColors.dark.onTertiary)
        TertiaryContainer = CustomColor(light: jsonColors.light.TertiaryContainer, dark: jsonColors.dark.TertiaryContainer)
        onTertiaryContainer = CustomColor(light: jsonColors.light.onTertiaryContainer, dark: jsonColors.dark.onTertiaryContainer)
        TertiaryFixed = CustomColor(light: jsonColors.light.TertiaryFixed ?? "", dark: jsonColors.dark.TertiaryFixed ?? "")
        TertiaryFixedDim = CustomColor(light: jsonColors.light.TertiaryFixedDim ?? "", dark: jsonColors.dark.TertiaryFixedDim ?? "")
        onTertiaryFixed = CustomColor(light: jsonColors.light.onTertiaryFixed ?? "", dark: jsonColors.dark.onTertiaryFixed ?? "")
        onTertiaryFixedVariant = CustomColor(light: jsonColors.light.onTertiaryFixedVariant ?? "", dark: jsonColors.dark.onTertiaryFixedVariant ?? "")
        
        Error = CustomColor(light: jsonColors.light.Error, dark: jsonColors.dark.Error)
        ErrorContainer = CustomColor(light: jsonColors.light.ErrorContainer, dark: jsonColors.dark.ErrorContainer)
        onError = CustomColor(light: jsonColors.light.onError, dark: jsonColors.dark.onError)
        onErrorContainer = CustomColor(light: jsonColors.light.onErrorContainer, dark: jsonColors.dark.onErrorContainer)
        
        Surface = CustomColor(light: jsonColors.light.Surface, dark: jsonColors.dark.Surface)
        SurfaceDim = CustomColor(light: jsonColors.light.SurfaceDim ?? "", dark: jsonColors.dark.SurfaceDim ?? "")
        SurfaceBright = CustomColor(light: jsonColors.light.SurfaceBright ?? "", dark: jsonColors.dark.SurfaceBright ?? "")
        
        SurfaceContainerLowest = CustomColor(light: jsonColors.light.SurfaceContainerLowest ?? "", dark: jsonColors.dark.SurfaceContainerLowest ?? "")
        SurfaceContainerLow = CustomColor(light: jsonColors.light.SurfaceContainerLow ?? "", dark: jsonColors.dark.SurfaceContainerLow ?? "")
        SurfaceContainer = CustomColor(light: jsonColors.light.SurfaceContainer, dark: jsonColors.dark.SurfaceContainer)
        SurfaceContainerHigh = CustomColor(light: jsonColors.light.SurfaceContainerHigh ?? "", dark: jsonColors.dark.SurfaceContainerHigh ?? "")
        SurfaceContainerHighest = CustomColor(light: jsonColors.light.SurfaceContainerHighest ?? "", dark: jsonColors.dark.SurfaceContainerHighest ?? "")
        
        onSurface = CustomColor(light: jsonColors.light.onSurface, dark: jsonColors.dark.onSurface)
        onSurfaceVariant = CustomColor(light: jsonColors.light.onSurfaceVariant, dark: jsonColors.dark.onSurfaceVariant)
        Outline = CustomColor(light: jsonColors.light.Outline, dark: jsonColors.dark.Outline)
        OutlineVariant = CustomColor(light: jsonColors.light.OutlineVariant, dark: jsonColors.dark.OutlineVariant)
        InverseSurface = CustomColor(light: jsonColors.light.InverseSurface, dark: jsonColors.dark.InverseSurface)
        InverseOnSurface = CustomColor(light: jsonColors.light.InverseOnSurface, dark: jsonColors.dark.InverseOnSurface)
        InversePrimary = CustomColor(light: jsonColors.light.InversePrimary, dark: jsonColors.dark.InversePrimary)
        
        Scrim = CustomColor(light: jsonColors.light.Scrim, dark: jsonColors.dark.Scrim)
        Shadow = CustomColor(light: jsonColors.light.Shadow ?? "", dark: jsonColors.dark.Shadow ?? "")
    }
    
    func storeToJson() {
        // Encode Person to JSON
        let colors = JSONColors(dark: SubColors(Primary: Primary.dark, onPrimary: onPrimary.dark, PrimaryContainer: PrimaryContainer.dark, onPrimaryContainer: onPrimaryContainer.dark, PrimaryFixed: PrimaryFixed?.dark, PrimaryFixedDim: PrimaryFixedDim?.dark, onPrimaryFixed: onPrimaryFixed?.dark, onPrimaryFixedVariant: onPrimaryFixedVariant?.dark, Secondary: Secondary.dark, onSecondary: onSecondary.dark, SecondaryContainer: SecondaryContainer.dark, onSecondaryContainer: onSecondaryContainer.dark, SecondaryFixed: SecondaryFixed?.dark, SecondaryFixedDim: SecondaryFixedDim?.dark, onSecondaryFixed: onSecondaryFixed?.dark, onSecondaryFixedVariant: onSecondaryFixedVariant?.dark, Tertiary: Tertiary.dark, onTertiary: onTertiary.dark, TertiaryContainer: TertiaryContainer.dark, onTertiaryContainer: onTertiaryContainer.dark, TertiaryFixed: TertiaryFixed?.dark, TertiaryFixedDim: TertiaryFixedDim?.dark, onTertiaryFixed: onTertiaryFixed?.dark, onTertiaryFixedVariant: onTertiaryFixedVariant?.dark, Error: Error.dark, ErrorContainer: ErrorContainer.dark, onError: onError.dark, onErrorContainer: onErrorContainer.dark, Surface: Surface.dark, SurfaceDim: SurfaceDim?.dark, SurfaceBright: SurfaceBright?.dark, SurfaceContainerLowest: SurfaceContainerLowest?.dark, SurfaceContainerLow: SurfaceContainerLow?.dark, SurfaceContainer: SurfaceContainer.dark, SurfaceContainerHigh: SurfaceContainerHigh?.dark, SurfaceContainerHighest: SurfaceContainerHighest?.dark, onSurface: onSurface.dark, onSurfaceVariant: onSurfaceVariant.dark, Outline: Outline.dark, OutlineVariant: OutlineVariant.dark, InverseSurface: InverseSurface.dark, InverseOnSurface: InverseOnSurface.dark, InversePrimary: InversePrimary.dark, Scrim: Scrim.dark, Shadow: Shadow?.dark), light: SubColors(Primary: Primary.light, onPrimary: onPrimary.light, PrimaryContainer: PrimaryContainer.light, onPrimaryContainer: onPrimaryContainer.light, PrimaryFixed: PrimaryFixed?.light, PrimaryFixedDim: PrimaryFixedDim?.light, onPrimaryFixed: onPrimaryFixed?.light, onPrimaryFixedVariant: onPrimaryFixedVariant?.light, Secondary: Secondary.light, onSecondary: onSecondary.light, SecondaryContainer: SecondaryContainer.light, onSecondaryContainer: onSecondaryContainer.light, SecondaryFixed: SecondaryFixed?.light, SecondaryFixedDim: SecondaryFixedDim?.light, onSecondaryFixed: onSecondaryFixed?.light, onSecondaryFixedVariant: onSecondaryFixedVariant?.light, Tertiary: Tertiary.light, onTertiary: onTertiary.light, TertiaryContainer: TertiaryContainer.light, onTertiaryContainer: onTertiaryContainer.light, TertiaryFixed: TertiaryFixed?.light, TertiaryFixedDim: TertiaryFixedDim?.light, onTertiaryFixed: onTertiaryFixed?.light, onTertiaryFixedVariant: onTertiaryFixedVariant?.light, Error: Error.light, ErrorContainer: ErrorContainer.light, onError: onError.light, onErrorContainer: onErrorContainer.light, Surface: Surface.light, SurfaceDim: SurfaceDim?.light, SurfaceBright: SurfaceBright?.light, SurfaceContainerLowest: SurfaceContainerLowest?.light, SurfaceContainerLow: SurfaceContainerLow?.light, SurfaceContainer: SurfaceContainer.light, SurfaceContainerHigh: SurfaceContainerHigh?.light, SurfaceContainerHighest: SurfaceContainerHighest?.light, onSurface: onSurface.light, onSurfaceVariant: onSurfaceVariant.light, Outline: Outline.light, OutlineVariant: OutlineVariant.light, InverseSurface: InverseSurface.light, InverseOnSurface: InverseOnSurface.light, InversePrimary: InversePrimary.light, Scrim: Scrim.light, Shadow: Shadow?.light))
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(colors) {
            // jsonString can be saved to file, UserDefaults or a database
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent("Themes").appendingPathComponent("default.theme")
                
                do {
                    try jsonData.write(to: fileURL)
                } catch {
                    print("Error writing JSON data: \(error)")
                }
            }
        }
    }
    
    func getAsJson() -> String {
        let colors = JSONColors(dark: SubColors(Primary: Primary.dark, onPrimary: onPrimary.dark, PrimaryContainer: PrimaryContainer.dark, onPrimaryContainer: onPrimaryContainer.dark, PrimaryFixed: PrimaryFixed?.dark, PrimaryFixedDim: PrimaryFixedDim?.dark, onPrimaryFixed: onPrimaryFixed?.dark, onPrimaryFixedVariant: onPrimaryFixedVariant?.dark, Secondary: Secondary.dark, onSecondary: onSecondary.dark, SecondaryContainer: SecondaryContainer.dark, onSecondaryContainer: onSecondaryContainer.dark, SecondaryFixed: SecondaryFixed?.dark, SecondaryFixedDim: SecondaryFixedDim?.dark, onSecondaryFixed: onSecondaryFixed?.dark, onSecondaryFixedVariant: onSecondaryFixedVariant?.dark, Tertiary: Tertiary.dark, onTertiary: onTertiary.dark, TertiaryContainer: TertiaryContainer.dark, onTertiaryContainer: onTertiaryContainer.dark, TertiaryFixed: TertiaryFixed?.dark, TertiaryFixedDim: TertiaryFixedDim?.dark, onTertiaryFixed: onTertiaryFixed?.dark, onTertiaryFixedVariant: onTertiaryFixedVariant?.dark, Error: Error.dark, ErrorContainer: ErrorContainer.dark, onError: onError.dark, onErrorContainer: onErrorContainer.dark, Surface: Surface.dark, SurfaceDim: SurfaceDim?.dark, SurfaceBright: SurfaceBright?.dark, SurfaceContainerLowest: SurfaceContainerLowest?.dark, SurfaceContainerLow: SurfaceContainerLow?.dark, SurfaceContainer: SurfaceContainer.dark, SurfaceContainerHigh: SurfaceContainerHigh?.dark, SurfaceContainerHighest: SurfaceContainerHighest?.dark, onSurface: onSurface.dark, onSurfaceVariant: onSurfaceVariant.dark, Outline: Outline.dark, OutlineVariant: OutlineVariant.dark, InverseSurface: InverseSurface.dark, InverseOnSurface: InverseOnSurface.dark, InversePrimary: InversePrimary.dark, Scrim: Scrim.dark, Shadow: Shadow?.dark), light: SubColors(Primary: Primary.light, onPrimary: onPrimary.light, PrimaryContainer: PrimaryContainer.light, onPrimaryContainer: onPrimaryContainer.light, PrimaryFixed: PrimaryFixed?.light, PrimaryFixedDim: PrimaryFixedDim?.light, onPrimaryFixed: onPrimaryFixed?.light, onPrimaryFixedVariant: onPrimaryFixedVariant?.light, Secondary: Secondary.light, onSecondary: onSecondary.light, SecondaryContainer: SecondaryContainer.light, onSecondaryContainer: onSecondaryContainer.light, SecondaryFixed: SecondaryFixed?.light, SecondaryFixedDim: SecondaryFixedDim?.light, onSecondaryFixed: onSecondaryFixed?.light, onSecondaryFixedVariant: onSecondaryFixedVariant?.light, Tertiary: Tertiary.light, onTertiary: onTertiary.light, TertiaryContainer: TertiaryContainer.light, onTertiaryContainer: onTertiaryContainer.light, TertiaryFixed: TertiaryFixed?.light, TertiaryFixedDim: TertiaryFixedDim?.light, onTertiaryFixed: onTertiaryFixed?.light, onTertiaryFixedVariant: onTertiaryFixedVariant?.light, Error: Error.light, ErrorContainer: ErrorContainer.light, onError: onError.light, onErrorContainer: onErrorContainer.light, Surface: Surface.light, SurfaceDim: SurfaceDim?.light, SurfaceBright: SurfaceBright?.light, SurfaceContainerLowest: SurfaceContainerLowest?.light, SurfaceContainerLow: SurfaceContainerLow?.light, SurfaceContainer: SurfaceContainer.light, SurfaceContainerHigh: SurfaceContainerHigh?.light, SurfaceContainerHighest: SurfaceContainerHighest?.light, onSurface: onSurface.light, onSurfaceVariant: onSurfaceVariant.light, Outline: Outline.light, OutlineVariant: OutlineVariant.light, InverseSurface: InverseSurface.light, InverseOnSurface: InverseOnSurface.light, InversePrimary: InversePrimary.light, Scrim: Scrim.light, Shadow: Shadow?.light))
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(colors) {
            // Store JSON data
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        return ""
    }
}
