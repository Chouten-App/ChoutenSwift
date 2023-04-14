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
    
    init(
        collections: Collections,
        scrollDirection: ScrollDirection = .vertical,
        contentSize: ContentSize,
        itemSpacing: ItemSpacing = ItemSpacing(mainAxisSpacing: 0, crossAxisSpacing: 0),
        rawCustomize: RawCustomize? = nil,
        contentForData: @escaping ContentForData,
        rtl: Bool)
    {
        self.collections = collections
        self.scrollDirection = scrollDirection
        self.contentSize = contentSize
        self.itemSpacing = itemSpacing
        self.rawCustomize = rawCustomize
        self.contentForData = contentForData
        self.rtl = rtl
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
        rtl: Bool) where Collections == [Collection]
    {
        self.init(
            collections: [collection],
            scrollDirection: scrollDirection,
            contentSize: contentSize,
            itemSpacing: itemSpacing,
            rawCustomize: rawCustomize,
            contentForData: contentForData,
            rtl: rtl)
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
            print(viewController?.collectionView.visibleCurrentCellIndexPath)
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
        .onAppear {
            let userinfo: [String: Int] = ["currentPage": data.page]
            NotificationCenter.default.post(Notification(name: .currentPage,
                                                         object: nil,
                                                         userInfo: userinfo))
        }
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

struct TESTING: View {
    
    @State var images: [mangaImages]? = nil
    @State var items: [MyCustomData]? = nil
    @State var rtl: Bool = true
    @State var scrollIndex: Int = 0
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
                                rtl: rtl)
                            .frame(height: proxy.size.height)
                            .flipsForRightToLeftLayoutDirection(rtl)
                            .environment(\.layoutDirection, rtl ? .rightToLeft : .leftToRight)
                        }
                    }
                }
                
                VStack {
                    ZStack {
                        Color(hex: "#ff91A6FF")
                        
                        Text("\(scrollIndex) / \(images?.count ?? 1)")
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                    }
                    .fixedSize()
                    .cornerRadius(8)
                    .padding(.bottom, 60)
                    .onReceive(notificationChanged) { note in
                        self.scrollIndex = note.userInfo!["currentPage"]! as! Int
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
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
