
# FromMatchedGeometry transition

SwiftUI transition using `matchedGeometryEffect`.

At the start of transition (when the view is inserted in the view hierarchy), the view will be placed matching geometry of the source view with matching **id** and **namespace**. Then it will move to it's normal place, no longer matching source view. Reverse when it is removed from the view hierarchy.

## Install

**Recommended**

Copy `FromMatchedGeomertry.swift` to your project.

**SPM**

Add this repo using Swift Package Manager: <https://github.com/nikstar/FromMatchedGeometry>

## Contrived exapmle

```swift

import FromMatchedGeometry

struct ContentView: View {
 
    @State private var showInsertedView = false
    @Namespace private var ns
    
    var body: some View {
        
        VStack {
            SourceView()
                .matchedGeometryEffect(id: 0, in: ns, isSource: true)
                .onTapGesture { showInsertedView.toggle() }
            
            if showInsertedView {
               TargetView()
                    .transition(
                        .fromMatchedGeometry(id: 0, in: ns)
                    )
            }
        }
        .animation(.bouncy, value: showInsertedView)
    }
}
```


## Full example

Full example from demo video is available in FromMatchedGeomertry.swift as a `#Preview`.
