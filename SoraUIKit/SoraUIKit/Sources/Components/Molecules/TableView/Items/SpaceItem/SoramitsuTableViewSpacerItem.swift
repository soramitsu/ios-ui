import UIKit

public final class SoramitsuTableViewSpacerItem: NSObject {

	private let space: CGFloat

	public var color: SoramitsuColor
    
    public var radius: Radius
    
    public var mask: CornerMask

    public init(space: CGFloat, 
                color: SoramitsuColor = .bgSurface,
                radius: Radius = .zero,
                mask: CornerMask = .all) {
		self.space = space
        self.color = color
        self.radius = radius
        self.mask = mask
	}

}

extension SoramitsuTableViewSpacerItem: SoramitsuTableViewItemProtocol {
	public var cellType: AnyClass {
		SoramitsuCell<SoramitsuTableViewSpaceView>.self
	}

	public func itemHeight(forWidth width: CGFloat, context: SoramitsuTableViewContext?) -> CGFloat {
		return space
	}
}
