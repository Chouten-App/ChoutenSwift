//
//  TESTING.swift
//  ModularSaikouS
//
//  Created by Inumaki on 09.04.23.
//

import SwiftUI
import SwiftUIX
import UIKit
import Kingfisher

extension Notification.Name {
    static var currentPage: Notification.Name { return .init("currentPage") }
}

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}

struct CollectionView
<Collections, CellContent>
: UIViewControllerRepresentable
where
Collections : RandomAccessCollection,
Collections.Index == Int,
Collections.Element : RandomAccessCollection,
Collections.Element.Index == Int,
Collections.Element.Element : Identifiable,
CellContent : View
{
    
    typealias Row = Collections.Element
    typealias Data = Row.Element
    typealias ContentForData = (Data) -> CellContent
    typealias ScrollDirection = UICollectionView.ScrollDirection
    typealias SizeForData = (Data) -> CGSize
    typealias CustomSizeForData = (UICollectionView, UICollectionViewLayout, Data) -> CGSize
    typealias RawCustomize = (UICollectionView) -> Void
    
    enum ContentSize {
        case fixed(CGSize)
        case variable(SizeForData)
        case crossAxisFilled(mainAxisLength: CGFloat)
        case custom(CustomSizeForData)
        case fit
    }
    
    struct ItemSpacing : Hashable {
        
        var mainAxisSpacing: CGFloat
        var crossAxisSpacing: CGFloat
    }
    
    fileprivate let collections: Collections
    fileprivate let contentForData: ContentForData
    fileprivate let scrollDirection: ScrollDirection
    fileprivate let contentSize: ContentSize
    fileprivate let itemSpacing: ItemSpacing
    fileprivate let rawCustomize: RawCustomize?
    fileprivate let rtl: Bool
    @Binding var scrollIndex: Double
    @Binding var seeking: Bool
    
    
    init(
        collections: Collections,
        scrollDirection: ScrollDirection = .vertical,
        contentSize: ContentSize,
        itemSpacing: ItemSpacing = ItemSpacing(mainAxisSpacing: 0, crossAxisSpacing: 0),
        rawCustomize: RawCustomize? = nil,
        contentForData: @escaping ContentForData,
        rtl: Bool,
        scrollIndex: Binding<Double>,
        seeking: Binding<Bool>)
    {
        self.collections = collections
        self.scrollDirection = scrollDirection
        self.contentSize = contentSize
        self.itemSpacing = itemSpacing
        self.rawCustomize = rawCustomize
        self.contentForData = contentForData
        self.rtl = rtl
        self._scrollIndex = scrollIndex
        self._seeking = seeking
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(view: self)
    }
    
    func makeUIViewController(context: Context) -> ViewController {
        let coordinator = context.coordinator
        let viewController = ViewController(coordinator: coordinator, scrollDirection: self.scrollDirection)
        coordinator.viewController = viewController
        self.rawCustomize?(viewController.collectionView)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // TODO: Obviously we can be efficient about what needs to be updated here
        context.coordinator.view = self
        uiViewController.layout.scrollDirection = self.scrollDirection
        self.rawCustomize?(uiViewController.collectionView)
        uiViewController.collectionView.reloadData()
        
        if seeking {
            // Get the IndexPath of the item you want to scroll to
            let indexPathToScrollTo = IndexPath(item: (Int)(scrollIndex), section: 0)

            // Scroll the UICollectionView to the desired index
            uiViewController.collectionView.scrollToItem(at: indexPathToScrollTo, at: .centeredHorizontally, animated: false)
        }
        
    }
}

extension CollectionView {
    
    /*
     Convenience init for a single-section CollectionView
     */
    init<Collection>(
        collection: Collection,
        scrollDirection: ScrollDirection = .vertical,
        contentSize: ContentSize,
        itemSpacing: ItemSpacing = ItemSpacing(mainAxisSpacing: 0, crossAxisSpacing: 0),
        rawCustomize: RawCustomize? = nil,
        contentForData: @escaping ContentForData,
        rtl: Bool,
        scrollIndex: Binding<Double>,
        seeking: Binding<Bool>) where Collections == [Collection]
    {
        self.init(
            collections: [collection],
            scrollDirection: scrollDirection,
            contentSize: contentSize,
            itemSpacing: itemSpacing,
            rawCustomize: rawCustomize,
            contentForData: contentForData,
            rtl: rtl,
            scrollIndex: scrollIndex,
            seeking: seeking)
    }
}

extension CollectionView {
    
    fileprivate static var cellReuseIdentifier: String {
        return "HostedCollectionViewCell"
    }
}

extension CollectionView {
    
    final class ViewController : UIViewController {
        
        fileprivate let layout: SnappingCollectionViewLayout
        fileprivate let collectionView: UICollectionView
        
        init(coordinator: Coordinator, scrollDirection: ScrollDirection) {
            let layout = SnappingCollectionViewLayout()
            layout.scrollDirection = scrollDirection
            self.layout = layout
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = nil
            collectionView.register(HostedCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
            collectionView.dataSource = coordinator
            collectionView.delegate = coordinator
            collectionView.decelerationRate = UICollectionView.DecelerationRate.fast
            self.collectionView = collectionView
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("In no way is this class related to an interface builder file.")
        }
        
        override func loadView() {
            self.view = self.collectionView
        }
    }
}

extension CollectionView {
    
    final class Coordinator : NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        fileprivate var view: CollectionView
        fileprivate var viewController: ViewController?
        
        init(view: CollectionView) {
            self.view = view
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return self.view.collections.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.view.collections[section].count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! HostedCollectionViewCell
            let data = self.view.collections[indexPath.section][indexPath.item]
            let content = self.view.contentForData(data)
            cell.provide(content)
            cell.transform = CGAffineTransform(scaleX: self.view.rtl ? -1 : 1, y: 1)
            
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            let cell = cell as! HostedCollectionViewCell
            cell.attach(to: self.viewController!)
        }
        
        func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            let cell = cell as! HostedCollectionViewCell
            cell.detach()
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            switch self.view.contentSize {
            case .fixed(let size):
                return size
            case .variable(let sizeForData):
                let data = self.view.collections[indexPath.section][indexPath.item]
                return sizeForData(data)
            case .crossAxisFilled(let mainAxisLength):
                switch self.view.scrollDirection {
                case .horizontal:
                    return CGSize(width: mainAxisLength, height: collectionView.bounds.height)
                case .vertical:
                    fallthrough
                @unknown default:
                    return CGSize(width: collectionView.bounds.width, height: mainAxisLength)
                }
            case .fit:
                return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
            case .custom(let customSizeForData):
                let data = self.view.collections[indexPath.section][indexPath.item]
                return customSizeForData(collectionView, collectionViewLayout, data)
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return self.view.itemSpacing.mainAxisSpacing
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return self.view.itemSpacing.crossAxisSpacing
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if viewController != nil {
                let visibleRect = CGRect(origin: viewController!.collectionView.contentOffset, size: viewController!.collectionView.bounds.size)
                let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                guard let indexPath = viewController!.collectionView.indexPathForItem(at: visiblePoint) else { return }
                view.scrollIndex = Double(indexPath.row + 1)
            }
        }
    }
}

extension UICollectionView {
  var visibleCurrentCellIndexPath: IndexPath? {
    for cell in self.visibleCells {
      let indexPath = self.indexPath(for: cell)
      return indexPath
    }
    
    return nil
  }
}

private extension CollectionView {
    
    final class HostedCollectionViewCell : UICollectionViewCell {
        
        var viewController: UIHostingController<CellContent>?
        
        func provide(_ content: CellContent) {
            if let viewController = self.viewController {
                viewController.rootView = content
            } else {
                let hostingController = UIHostingController(rootView: content)
                hostingController.view.backgroundColor = nil
                self.viewController = hostingController
            }
        }
        
        func attach(to parentController: UIViewController) {
            let hostedController = self.viewController!
            let hostedView = hostedController.view!
            let contentView = self.contentView
            
            parentController.addChild(hostedController)
            
            hostedView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(hostedView)
            hostedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            hostedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            hostedView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            hostedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            
            hostedController.didMove(toParent: parentController)
        }
        
        func detach() {
            let hostedController = self.viewController!
            guard hostedController.parent != nil else { return }
            let hostedView = hostedController.view!
            
            hostedController.willMove(toParent: nil)
            hostedView.removeFromSuperview()
            hostedController.removeFromParent()
        }
    }
}


// Usage:
struct MyCustomData : Identifiable {
    let id: String
    let img: String
    let page: Int
    let nextChapter: Bool
}

struct MyCustomCell : View {
    
    let data: MyCustomData
    
    var body: some View {
        ZStack(alignment: .center) {
            if !data.nextChapter {
                KFImage(URL(string: data.img))
                    .placeholder({ Progress in
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.4),style: StrokeStyle(lineWidth: 4))
                                .rotationEffect(.init(degrees: -90))
                                .frame(maxWidth: 60)
                                .animation(.linear)
                            Circle()
                                .trim(from: 0, to: Progress.fractionCompleted)
                                .stroke(Color.white,style: StrokeStyle(lineWidth: 4))
                                .rotationEffect(.init(degrees: -90))
                                .frame(maxWidth: 60)
                                .animation(.linear)
                        }
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                //NextChapterDisplay(currentChapter: "Volume 1 Chapter 1", nextChapter: "Volume 1 Chapter 2", status: "Ready")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct mangaImages: Codable {
    let page: Int
    let img: String
}

struct ChapterManager: Codable {
    var previous: [mangaImages]?
    var current: [mangaImages]
    var next: [mangaImages]?
}

struct Seekbar: View {
    
    @Binding var percentage: Double // or some value binded
    @Binding var buffered: Double
    @Binding var isDragging: Bool
    var total: Double
    @Binding var isMacos: Bool
    @State var barHeight: CGFloat = 6
    
    
    var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .bottomLeading) {
                
                Rectangle()
                    .foregroundColor(.white.opacity(0.4)).frame(height: barHeight, alignment: .bottom).cornerRadius(12)
                
                Rectangle()
                    .foregroundColor(.white.opacity(0.4))
                    .frame(width: geometry.size.width * CGFloat(self.buffered / total)).frame(height: barHeight, alignment: .bottom).cornerRadius(12)
                
                Rectangle()
                    .foregroundColor(Color("accentColor1"))
                    .frame(width: geometry.size.width * CGFloat(self.percentage / total)).frame(height: barHeight, alignment: .bottom).cornerRadius(12)
            }.frame(maxHeight: .infinity, alignment: .center)
                .cornerRadius(12)
                .overlay {
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0)
                            .onEnded({ value in
                                self.percentage = min(max(0, Double(value.location.x / geometry.size.width * total)), total)
                                self.isDragging = false
                                self.barHeight = isMacos ? 12 : 6
                            })
                            .onChanged({ value in
                                    self.isDragging = true
                                    self.barHeight = isMacos ? 18 : 10
                                    print(value)
                                    // TODO: - maybe use other logic here
                                    self.percentage = min(max(0, Double(value.location.x / geometry.size.width * total)), total)
                                })
                        )
                }
                .animation(.spring(response: 0.3), value: self.isDragging)
            
        }
    }
}

enum ReadMode {
    case rtl
    case ltr
    case vertical
}

struct TESTING: View {
    
    @State var images: [mangaImages]? = nil
    @State var items: [MyCustomData]? = nil
    @State var rtl: Bool = true
    @State var vertical: Bool = false
    @State var scrollIndex: Double = 1
    var notificationChanged = NotificationCenter.default.publisher(for: .currentPage)
    
    func getImages(id: String, provider: String) async -> [mangaImages]? {
        print("https://api.consumet.org/meta/anilist-manga/read?chapterId=\(id)&provider=\(provider)")
        guard let url = URL(string: "https://api.consumet.org/meta/anilist-manga/read?chapterId=\(id)&provider=\(provider)") else {
            //completion(.failure(error: AnilistFetchError.invalidUrlProvided))
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let data = try JSONDecoder().decode([mangaImages].self, from: data)
                return data
                //completion(.success(data: data))
            } catch let error {
                print(error)
                //completion(.failure(error: AnilistFetchError.dataParsingFailed(reason: error)))
            }
            
        } catch let error {
            print(error)
            //completion(.failure(error: AnilistFetchError.dataLoadFailed))
        }
        return nil
    }
    
    @State var isDragging = false
    @State var showUI = false
    @State var showSettings = false
    @State var readMode: ReadMode = .rtl
    
    @Namespace var animation
    
    var body: some View {
        GeometryReader {proxy in
            ZStack(alignment: .center) {
                Color(.black)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        if items != nil {
                            CollectionView(
                                collection: self.items!,
                                scrollDirection: .horizontal,
                                contentSize: .crossAxisFilled(mainAxisLength: proxy.size.width),
                                itemSpacing: .init(mainAxisSpacing: 0, crossAxisSpacing: 0),
                                rawCustomize: { collectionView in
                                    collectionView.showsHorizontalScrollIndicator = false
                                    collectionView.showsVerticalScrollIndicator = false
                                },
                                contentForData: MyCustomCell.init,
                                rtl: rtl,
                                scrollIndex: $scrollIndex,
                                seeking: $isDragging)
                            .frame(height: proxy.size.height)
                            .flipsForRightToLeftLayoutDirection(rtl)
                            .environment(\.layoutDirection, rtl ? .rightToLeft : .leftToRight)
                        }
                    }
                }
                .onTapGesture {
                    showUI.toggle()
                }
                
                VStack {
                    //top part
                    HStack {
                        Button(action: {
                            //self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            ZStack {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .fixedSize()
                        })
                        
                        Spacer()
                            .frame(maxWidth: 12)
                        
                        
                        VStack {
                            Text("1: Tragedy")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Tokyo Ghoul")
                                .font(.subheadline)
                                .bold()
                                .opacity(0.7)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        Spacer()
                        
                        Image(systemName: "gear")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .onTapGesture {
                                showSettings.toggle()
                            }
                         
                    }
                    .opacity(showUI ? 1.0 : 0.0)
                    
                    Spacer()
                    
                    // bottom part
                    VStack {
                        Seekbar(percentage: $scrollIndex, buffered: .constant(0.0), isDragging: $isDragging, total: (Double)(images?.count ?? 1), isMacos: .constant(false))
                            .frame(maxHeight: 18)
                            .flipsForRightToLeftLayoutDirection(rtl)
                            .environment(\.layoutDirection, rtl ? .rightToLeft : .leftToRight)
                        
                        HStack {
                            Text("Page \((Int)(scrollIndex))")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(images?.count ?? 1) Pages")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .offset(y: -6)
                    }
                    .opacity(showUI ? 1.0 : 0.0)
                }
                .foregroundColor(Color("textColor2"))
                .padding(.horizontal, 20)
                .padding(.vertical, 60)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .background {
                    Color.black.opacity(showUI ? 0.4 : 0.0)
                        .allowsHitTesting(false)
                }
                .animation(.spring(response: 0.3), value: showUI)
                .onReceive(notificationChanged) { note in
                    self.scrollIndex = (Double)(note.userInfo!["currentPage"]! as! Int)
                }
            }
            .popup(isPresented: $showSettings, isHorizontal: false) {
                VStack(alignment: .leading) {
                    Text("Settings")
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 12)
                    
                    Text("Reading Mode")
                    // read modes
                    HStack {
                        Text("Right To Left")
                            .frame(maxWidth: (proxy.size.width - 40) / 3, maxHeight: .infinity)
                            .background {
                                if readMode == .rtl {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color("bg2"))
                                        .matchedGeometryEffect(id: "readmode", in: animation)
                                }
                            }
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    readMode = .rtl
                                }
                            }
                        
                        Text("Left To Right")
                            .frame(maxWidth: (proxy.size.width - 40) / 3, maxHeight: .infinity)
                            .background {
                                if readMode == .ltr {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color("bg2"))
                                        .matchedGeometryEffect(id: "readmode", in: animation)
                                }
                            }
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    readMode = .ltr
                                }
                            }
                        
                        Text("Vertical")
                            .frame(maxWidth: (proxy.size.width - 40) / 3, maxHeight: .infinity)
                            .background {
                                if readMode == .vertical {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color("bg2"))
                                        .matchedGeometryEffect(id: "readmode", in: animation)
                                }
                            }
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    readMode = .vertical
                                }
                            }
                    }
                    .padding(4)
                    .frame(maxHeight: 40)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("bg"))
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: proxy.size.width, maxHeight: 360, alignment: .topLeading)
                .background {
                    Color("bg2")
                }
                .cornerRadius([.topLeading, .topTrailing], 20)
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                images = await getImages(id: "0615033f-404c-4a57-a595-613a6277f553", provider: "mangadex")
                print(images)
                if(images != nil) {
                    items = images!.enumerated().map{ (index, mangaImage) in
                        MyCustomData(id: "\(index)", img: mangaImage.img, page: mangaImage.page, nextChapter: false)
                    }
                    items?.append(MyCustomData(id: "\(1000000)", img: "", page: images!.count, nextChapter: true))
                }
            }
        }
    }
}

struct TESTING_Previews: PreviewProvider {
    static var previews: some View {
        TESTING()
    }
}
