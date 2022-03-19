//
//  BottomSheetView.swift
//  SwiftUIMapKitTutorial
//
//  Created by BruceHuang on 2022/3/19.
//

import SwiftUI

struct BottomSheetView: View {
    
    @State var txt = ""
    
    @State var offset: CGFloat = 0
    
    @State var startLocationY: CGFloat = 0
    @State var translationHeight: CGFloat = 0
    @State var translationWidth: CGFloat = 0
    
    @State var value: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            // to read frame height
            VStack {
                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 50, height: 5)
                    .padding(.top)
                    .padding(.bottom, 5)
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                    
                    TextField("Search Place", text: $txt) { status in
                        withAnimation {
                            offset = -geo.frame(in: .global).height / 2
                        }
                    } onCommit: {
                        
                    }
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 15) {
                        ForEach(1...15, id: \.self) { count in
                            Text("Searched Place")
                            
                            Divider()
                                .padding(.top, 10)
                        }
                    }
                    .padding()
                    .padding(.top)
                }
            }
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(15)
            .offset(y: geo.frame(in: .global).height - 140)
            // adding Gesture
            .offset(y: offset)
            .gesture(DragGesture().onChanged({ value in
                startLocationY = value.startLocation.y
                translationHeight = value.translation.height
                translationWidth = value.translation.width
                
                withAnimation {
                    // checking Scroll direction
                    // scrolling upwards
                    // usingstartLocation because translation will change when we drag up and down
                    if value.startLocation.y > geo.frame(in: .global).midX {
                        if value.translation.height < 0 && offset > (-geo.frame(in: .global).height + 150) {
                            offset = value.translation.height
                        }
                    }
                    
                    if value.startLocation.y < geo.frame(in: .global).midX {
                        if value.translation.height > 0 && offset < 0 {
                            offset = (-geo.frame(in: .global).height + 150) + value.translation.height
                        }
                    }
                }
            }).onEnded({ value in
                withAnimation {
                    // checking and pulling up the screen
                    if value.startLocation.y > geo.frame(in: .global).midX {
                        if -value.translation.height > geo.frame(in: .global).midX {
                            offset = (-geo.frame(in: .global).height + 150)
                            return
                        }
                        offset = 0
                    }
                    
                    if value.startLocation.y < geo.frame(in: .global).midX {
                        if value.translation.height < geo.frame(in: .global).midX {
                            offset = (-geo.frame(in: .global).height + 150)
                            return
                        }
                        offset = 0
                    }
                }
            }))
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    
    static var previews: some View {
        BottomSheetView(value: 0)
    }
}

struct SlideOverCard<Content: View> : View {
    @GestureState private var dragState = DragState.inactive
    @State var position = CardPosition.top
    
    var content: () -> Content
    var body: some View {
        // updating -> changed -> ended
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                print("update...")
                state = .dragging(translation: drag.translation)
            }
//            .onChanged({ value in
//                print("change...")
//            })
            .onEnded(onDragEnded)
        
        return Group {
            self.content()
        }
        .frame(height: UIScreen.main.bounds.height)
        .background(Color.white)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        .offset(y: self.position.rawValue + self.dragState.translation.height)
        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0), value: dragState)
        .gesture(drag)
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = self.position.rawValue + drag.translation.height
        let positionAbove: CardPosition
        let positionBelow: CardPosition
        let closestPosition: CardPosition
        
        if cardTopEdgeLocation <= CardPosition.middle.rawValue {
            positionAbove = .top
            positionBelow = .middle
        } else {
            positionAbove = .middle
            positionBelow = .bottom
        }
        
        if (cardTopEdgeLocation - positionAbove.rawValue) < (positionBelow.rawValue - cardTopEdgeLocation) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }
        
        if verticalDirection > 0 {
            self.position = positionBelow
        } else if verticalDirection < 0 {
            self.position = positionAbove
        } else {
            self.position = closestPosition
        }
    }
}

enum CardPosition: CGFloat {
    case top = 100
    case middle = 500
    case bottom = 850
}

enum DragState: Equatable {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
