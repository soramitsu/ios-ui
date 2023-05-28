import UIKit

public enum DiffableTableViewType {

    case grouped

    case plain

    func makeDescriptor() -> AnyElementDescriptor<DiffableTableView> {
        switch self {
        case .grouped:
            return AnyElementDescriptor(descriptor: DiffableGroupedTableViewDescriptor())
        case .plain:
            return AnyElementDescriptor(descriptor: DiffablePlainTableViewDescriptor())
        }
    }

    func uiType() -> UITableView.Style {
        switch self {
        case .plain:
            return .plain
        case .grouped:
            return .grouped
        }
    }
}
