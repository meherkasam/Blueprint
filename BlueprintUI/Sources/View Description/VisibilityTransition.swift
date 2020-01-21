import UIKit

/// The transition used when a view is inserted or removed during an update cycle.
public struct VisibilityTransition {

    /// The alpha of the view in the hidden state (initial for appearing, final for disappearing).
    public var alpha: CGFloat

    /// The transform of the view in the hidden state (initial for appearing, final for disappearing).
    public var transform: CATransform3D

    /// The animation attributes that will be used to drive the transition.
    public var attributes: AnimationAttributes
    
    /// When the transition animation should be performed, if nested within other transition animations.
    public var performing : PerformRule
    
    public enum PerformRule : Hashable {
        /// The animation will always be performed, even if it is nested in other animations.
        case always
        
        /// The animation will only be performed if not nested in other transitions.
        case ifNotNested
    }

    public init(
        alpha: CGFloat,
        transform: CATransform3D,
        attributes: AnimationAttributes = .init(),
        performing: PerformRule = .ifNotNested,
        configure : (inout VisibilityTransition) -> () = { _ in }
    ) {
        self.alpha = alpha
        self.transform = transform
        self.attributes = attributes
        self.performing = performing
        
        configure(&self)
    }

    /// Returns a `VisibilityTransition` that scales in and out.
    public static var scale: VisibilityTransition {
        return VisibilityTransition(
            alpha: 1.0,
            transform: CATransform3DMakeScale(0.01, 0.01, 0.01))
    }

    /// Returns a `VisibilityTransition` that fades in and out.
    public static var fade: VisibilityTransition {
        return VisibilityTransition(
            alpha: 0.0,
            transform: CATransform3DIdentity)
    }

    /// Returns a `VisibilityTransition` that simultaneously scales and fades in and out.
    public static var scaleAndFade: VisibilityTransition {
        return VisibilityTransition(
            alpha: 0.0,
            transform: CATransform3DMakeScale(0.01, 0.01, 0.01))
    }
}


extension VisibilityTransition {
    
    func performAppearing(with view: UIView, layoutAttributes: LayoutAttributes) {

        UIView.performWithoutAnimation {
            self.getInvisibleAttributesFor(layoutAttributes: layoutAttributes).apply(to: view)
        }

        attributes.perform(
            animations: {
                layoutAttributes.apply(to: view)
            }
        )
    }

    func performDisappearing(with view: UIView, layoutAttributes: LayoutAttributes, completion: @escaping ()->Void) {

        attributes.perform(
            animations: {
                self.getInvisibleAttributesFor(layoutAttributes: layoutAttributes).apply(to: view)
            },
            completion: completion
        )

    }

    private func getInvisibleAttributesFor(layoutAttributes: LayoutAttributes) -> LayoutAttributes {
        var attributes = layoutAttributes
        attributes.transform = CATransform3DConcat(attributes.transform, transform)
        attributes.alpha *= alpha
        return attributes
    }
}
