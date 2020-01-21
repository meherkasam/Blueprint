import BlueprintUI
import UIKit


/// Wraps a content element and adds transitions when the element appears,
/// disappears, or changes layout.
public struct TransitionContainer: Element {

    public var appearingTransition: VisibilityTransition
    public var disappearingTransition: VisibilityTransition
    public var layoutTransition: LayoutTransition

    public var wrappedElement: Element

    public init(
        appearingTransition: VisibilityTransition = .fade,
        disappearingTransition: VisibilityTransition = .fade,
        layoutTransition: LayoutTransition = .specific(AnimationAttributes()),
        wrapping element: Element,
        configure : (inout TransitionContainer) -> () = { _ in }
    ) {
        self.appearingTransition = appearingTransition
        self.disappearingTransition = disappearingTransition
        self.layoutTransition = layoutTransition
        
        self.wrappedElement = element
        configure(&self)
    }

    public var content: ElementContent {
        return ElementContent(child: wrappedElement)
    }

    public func backingViewDescription(bounds: CGRect, subtreeExtent: CGRect?) -> ViewDescription? {
        return UIView.describe { config in
            config.appearingTransition = appearingTransition
            config.disappearingTransition = disappearingTransition
            config.layoutTransition = layoutTransition
        }
    }

}
