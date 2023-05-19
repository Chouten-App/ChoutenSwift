#if os(iOS)
import Foundation
import SwiftUI

class HostingController: UIHostingController<AnyView> {
    override var prefersHomeIndicatorAutoHidden: Bool { _prefersHomeIndicatorAutoHidden }

    var _prefersHomeIndicatorAutoHidden = false {
       didSet {
            setNeedsUpdateOfHomeIndicatorAutoHidden()
       }
   }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { _supportedInterfaceOrientations }

    private var _supportedInterfaceOrientations = UIInterfaceOrientationMask.all {
        didSet {
            if #available(iOS 16, *) {
                #if targetEnvironment(macCatalyst)
                #else
                setNeedsUpdateOfSupportedInterfaceOrientations()
                #endif
            } else {
                UIView.performWithoutAnimation {
                    if _supportedInterfaceOrientations.contains(.portrait) {
                        UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
                    } else if _supportedInterfaceOrientations.contains(.landscape) {
                        UIDevice.current.setValue(UIDeviceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                    }
                    UIViewController.attemptRotationToDeviceOrientation()
                }
            }
        }
    }

    override var shouldAutorotate: Bool { true }

    init<V: View>(wrappedView: V) {
        let box = Box()

        super.init(
            rootView:
                AnyView(
                    wrappedView
                        .onPreferenceChange(HomeIndicatorAutoHiddenPreferenceKey.self) { value in
                            box.delegate?._prefersHomeIndicatorAutoHidden = value
                        }
                        .onPreferenceChange(SupportedOrientationPreferenceKey.self) { value in
                            box.delegate?._supportedInterfaceOrientations = value
                        }
                )
        )

        box.delegate = self
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private class Box {
    weak var delegate: HostingController?

}

struct HomeIndicatorAutoHiddenPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(
        value: inout Bool,
        nextValue: () -> Bool
    ) {
        value = nextValue()
    }
}

struct SupportedOrientationPreferenceKey: PreferenceKey {
    static var defaultValue: UIInterfaceOrientationMask = .portrait

    static func reduce(
        value: inout UIInterfaceOrientationMask,
        nextValue: () -> UIInterfaceOrientationMask
    ) {
        value = nextValue()
    }
}

extension View {
    func prefersHomeIndicatorAutoHidden(_ value: Bool) -> some View {
        preference(key: HomeIndicatorAutoHiddenPreferenceKey.self, value: value)
    }

    func supportedOrientation(_ orientation: UIInterfaceOrientationMask) -> some View {
        preference(key: SupportedOrientationPreferenceKey.self, value: orientation)
    }
}

#endif
