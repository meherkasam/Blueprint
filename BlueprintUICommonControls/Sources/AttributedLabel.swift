import BlueprintUI
import UIKit

public struct AttributedLabel: Element {

    public var attributedText: NSAttributedString
    public var numberOfLines: Int = 0

    @Environment(\.screenScale) var screenScale

    public init(attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }

    public var content: ElementContent {
        struct Measurer: Measurable {

            var attributedText: NSAttributedString
            var roundingScale: CGFloat

            func measure(in constraint: SizeConstraint) -> CGSize {
                var size = attributedText.boundingRect(
                    with: constraint.maximum,
                    options: [.usesLineFragmentOrigin],
                    context: nil)
                    .size
                size.width = size.width.rounded(.up, by: screenScale)
                size.height = size.height.rounded(.up, by: screenScale)

                return size
            }
        }

        return ElementContent(measurable: Measurer(attributedText: attributedText, roundingScale: roundingScale))
    }

    public func backingViewDescription(bounds: CGRect, subtreeExtent: CGRect?) -> ViewDescription? {
        return UILabel.describe { (config) in
            config[\.attributedText] = attributedText
            config[\.numberOfLines] = numberOfLines
        }
    }

}
