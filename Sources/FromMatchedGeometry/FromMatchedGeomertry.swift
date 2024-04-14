
import SwiftUI

internal struct FromMatchedGeometryTransition<H: Hashable>: ViewModifier {
    
    var id: H
    var active: Namespace.ID
    var isActive: Bool
    var modifier: ((any View, Bool) -> any View)? = nil
    
    @Namespace private var identity
    
    
    func body(content: Content) -> some View {
        let content = content
            .matchedGeometryEffect(id: id, in: isActive ? active : identity, isSource: false)
            .allowsHitTesting(!isActive)

        if let modifier {
            AnyView(modifier(content, isActive))
        } else {
            content
        }
    }
}


extension AnyTransition {
    
    /// At the start of transition (when the view is inserted in the view hierarchy), the view will be placed matching geometry of the source view with matching **id** and **namespace**.
    /// Then it will move to it's normal place, no longer matching source view.
    /// Reverse when it is removed from the view hierarchy.
    public static func fromMatchedGeometry<H: Hashable>(id: H, in namespace: Namespace.ID, modifier: ((any View, Bool) -> any View)? = nil) -> AnyTransition {
        
        AnyTransition.modifier(
            active: FromMatchedGeometryTransition(id: id, active: namespace, isActive: true, modifier: modifier),
            identity: FromMatchedGeometryTransition(id: id, active: namespace, isActive: false, modifier: modifier)
        )
    }
}


#if DEBUG
@available(macOS 14, iOS 17, *)
#Preview("Full Example") {
   
    struct ListItem: View {

        var item: String
        
        var body: some View {
            Color.clear.opacity(0.5)
                .frame(height: 160)
                .border(Color.red, width: 4)
                .overlay {
                    Text(item)
                }
                .contentShape(Rectangle())
        }
    }

    struct ShelfItem: View {
        
        var item: String
        
        var body: some View {

            ZStack {
                Color.green.opacity(0.7)
                Text(item)
                    .padding()
            }
            .border(Color.green, width: 2)
        }
    }
    
    struct ExampleView: View {
        
        @State private var allItems: [String] = "Hello darkness, my old friend I've come to talk with you again".split(separator: " ").map(String.init)
        @State private var shelfItems: [String] = []
        
        @Namespace private var listNs
        
        var body: some View {
            list
                .safeAreaInset(edge: .top) { shelf }
        }
        
        var list: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    ForEach(allItems, id: \.self) { item in
                        ListItem(item: item)
                            .onTapGesture { addOrRemove(item: item) }
                            .matchedGeometryEffect(id: item, in: listNs, isSource: true) // we are matching this view
                    }
                }
                .padding(8)
            }
        }
        
        var shelf: some View {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(shelfItems, id: \.self) { item in
                        ShelfItem(item: item)
                            .onTapGesture { remove(item: item) }
                            .transition(
                                .fromMatchedGeometry(id: item, in: listNs, modifier: { content, isActive in
                                    content
                                        .fixedSize(horizontal: !isActive, vertical: !isActive)
                                })
                            )
                    }
                }
                .padding(.horizontal, 8)
                .frame(height: 80)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollClipDisabled() // important!

            .background(.background.secondary)
        }
        
        func addOrRemove(item: String) {
            if !shelfItems.contains(item) {
                add(item: item)
            } else {
                remove(item: item)
            }
        }
        
        func add(item: String) {
            withAnimation(.bouncy(duration: 1.35)) {
                shelfItems.append(item)
            }
        }
        
        func remove(item: String) {
            withAnimation(.snappy(duration: 1.25)) {
                shelfItems.removeAll(where: { $0 == item })
            }
        }
    }
    
    return ExampleView()
}
#endif

