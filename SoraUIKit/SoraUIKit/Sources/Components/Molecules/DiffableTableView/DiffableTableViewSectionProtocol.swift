public protocol DiffableTableViewSectionProtocol: BaseTableViewSectionProtocol {

    var header: DiffableTableViewItemProtocol? { get set }
    
    var footer: UIView? { get set }

    var context: DiffableTableViewContext? { get set }

    var rows: [DiffableTableViewItemProtocol] { get set }

    func heightForRow(at indexPath: IndexPath, boundingWidth: CGFloat) -> CGFloat

    func estimatedHeightForRow(at indexPath: IndexPath, boundingWidth: CGFloat) -> CGFloat?

    func heightForHeader(in section: Int, in tableView: DiffableTableView) -> CGFloat

    func cellForRow(at indexPath: IndexPath, in tableView: DiffableTableView) -> UITableViewCell

    func viewForHeader(in tableView: DiffableTableView) -> UIView?

    func didSelectRow(at indexPath: IndexPath)

    func leadingActions(at indexPath: IndexPath) -> [UIContextualAction]?

    func trailingActions(at indexPath: IndexPath) -> [UIContextualAction]?

    func canMoveRow(at indexPath: IndexPath) -> Bool
}
