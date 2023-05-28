import UIKit

public protocol DiffableTableViewCellProtocol: UIView {

    func prepareForReuse()

    func set(item: DiffableTableViewItemProtocol, context: DiffableTableViewContext?)
}

public extension DiffableTableViewCellProtocol {
    func prepareForReuse() {}
}

public extension DiffableTableViewCellProtocol {

    func updateCellSize(with animation: UITableView.RowAnimation = .automatic) {
        guard
            let cell = superview as? UITableViewCell,
            let tableView = cell.superview as? UITableView,
            let indexPath = tableView.indexPath(for: cell) else { return }
        DispatchQueue.main.async {
            tableView.performBatchUpdates({ tableView.reloadRows(at: [indexPath], with: animation) })
        }
    }
}
