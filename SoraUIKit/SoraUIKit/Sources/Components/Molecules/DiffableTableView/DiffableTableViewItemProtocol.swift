
import UIKit

public protocol DiffableTableViewItemProtocol: BaseTableViewItemProtocol {

    var cellType: AnyClass { get }

    var backgroundColor: SoramitsuColor { get }

    var selectionColor: SoramitsuColor? { get }

    var clipsToBounds: Bool { get }

    var isSectionHeader: Bool { get }

    var isHighlighted: Bool { get }

    var accessibilityLabel: String? { get set }

    var accessibilityHint: String? { get set }

    var accessibilityIdentifier: String? { get set }

    var accessibilityTraits: UIAccessibilityTraits { get set }

    var isAccessibilityElement: Bool { get set }

    var accessibilityElementsHidden: Bool { get set }

    var canMove: Bool { get }

    var leadingSwipeActions: [UIContextualAction]? { get }

    var trailingSwipeActions: [UIContextualAction]? { get }

    var menuActions: [SoramitsuMenuItemAction]? { get }

    func itemActionTap(with context: DiffableTableViewContext?)

    func itemHeight(forWidth width: CGFloat, context: DiffableTableViewContext?) -> CGFloat

    func itemEstimatedHeight(forWidth width: CGFloat) -> CGFloat?
}

public extension DiffableTableViewItemProtocol {
    var backgroundColor: SoramitsuColor {
        .bgSurface
    }

    var selectionColor: SoramitsuColor? {
        nil
    }

    var clipsToBounds: Bool {
        true
    }

    var isSectionHeader: Bool {
        false
    }

    var isHighlighted: Bool {
        false
    }

    var accessibilityLabel: String? {
        get {
            return nil
        }
        set {
            accessibilityLabel = newValue
        }
    }

    var accessibilityHint: String? {
        get {
            return nil
        }
        set {
            accessibilityHint = newValue
        }
    }

    var accessibilityIdentifier: String? {
        get {
            return nil
        }
        set {
            accessibilityIdentifier = newValue
        }
    }

    var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .button
        }
        set {
            accessibilityTraits = newValue
        }
    }

    var isAccessibilityElement: Bool {
        get {
            return false
        }
        set {
            isAccessibilityElement = newValue
        }
    }

    var accessibilityElementsHidden: Bool {
        get {
            return false
        }
        set {
            accessibilityElementsHidden = newValue
        }
    }

    var canMove: Bool {
        true
    }

    var leadingSwipeActions: [UIContextualAction]? {
        nil
    }

    var trailingSwipeActions: [UIContextualAction]? {
        nil
    }

    var menuActions: [SoramitsuMenuItemAction]? {
        nil
    }

    func itemHeight(forWidth width: CGFloat, context: DiffableTableViewContext?) -> CGFloat {
        UITableView.automaticDimension
    }

    func itemActionTap(with context: DiffableTableViewContext?) {
    }

    func itemEstimatedHeight(forWidth width: CGFloat) -> CGFloat? {
        nil
    }
}

extension DiffableTableViewItemProtocol {

    func reuseId() -> String {
        return String(describing: cellType)
    }
    
}
