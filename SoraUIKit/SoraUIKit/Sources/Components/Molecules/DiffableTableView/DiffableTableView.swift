import UIKit

public final class DiffableTableView: UITableView, Molecule {
    
    public let sora: DiffableTableViewConfiguration<DiffableTableView>
    
    public weak var tableViewObserver: SoramitsuTableViewObserver?
    public weak var scrollViewDelegate: UIScrollViewDelegate?

    fileprivate var shouldHandlePagination = true
    
    public var emptyView: UIView? = nil {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = emptyView {
                insertSubview(view, at: 0)
            }
            reloadEmptyView()
        }
    }
    
    private var loadingIndicatorShown = false {
        didSet {
            reloadEmptyView()
        }
    }
    
    init(style: SoramitsuStyle, tableViewType: DiffableTableViewType) {
        sora = DiffableTableViewConfiguration(style: style)
        super.init(frame: .zero, style: .plain)
        sora.owner = self
        alwaysBounceVertical = false
        tableViewType.makeDescriptor().configure(self)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(type: DiffableTableViewType = .plain,
                     configurator: ((DiffableTableViewConfiguration<DiffableTableView>) -> Void)? = nil) {
        self.init(style: SoramitsuUI.shared.style, tableViewType: type)
        configurator?(sora)
    }

    public convenience init() {
        self.init(style: SoramitsuUI.shared.style, tableViewType: .plain)
    }
    
    @objc public func resetPagination() {
        sora.updatePagination()
    }
    
    func updateRefreshControl() {
        if let handler = sora.paginationHandler, handler.possibleToMakePullToRefresh() {
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(resetPagination), for: .valueChanged)
        } else {
            refreshControl = nil
        }
        alwaysBounceVertical = (sora.paginationHandler?.possibleToMakePullToRefresh() ?? false) || alwaysBounceVertical
    }

    func reloadEmptyView() {
        UIView.animate(withDuration: CATransaction.animationDuration()) {
            self.emptyView?.alpha = !self.sora.doesHaveAnyRows() && !self.loadingIndicatorShown ? 1 : 0
        }
    }
    
    func addLoadingIndicator(position: PagePosition) {
        sora.paginationIndicator.start()
        switch position {
        case .bottom:
            sora.tableViewFooter = sora.paginationIndicator
        case .top:
            sora.tableViewHeader = sora.paginationIndicator
        }
        loadingIndicatorShown = true
    }

    func removeLoadingIndicator(position: PagePosition) {
        sora.paginationIndicator.stop()
        switch position {
        case .bottom:
            sora.tableViewFooter = nil
        case .top:
            sora.tableViewHeader = nil
        }

        if let type = sora.paginationHandler?.paginationType {
            switch type {
            case .both:
                loadingIndicatorShown = sora.tableViewFooter != nil || sora.tableViewHeader != nil
            case .bottom:
                loadingIndicatorShown = false
            }
        }
    }

    
}

extension DiffableTableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewObserver?.didSelectRow(at: indexPath)

        sora.sections[indexPath.section].didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section < sora.sections.count else { return 0 }
        return sora.sections[indexPath.section].heightForRow(at: indexPath, boundingWidth: tableView.bounds.width)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = sora.sections[indexPath.section].estimatedHeightForRow(at: indexPath, boundingWidth: tableView.bounds.width) {
            return height
        } else {
            return estimatedRowHeight
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section < sora.sections.count else {
            return nil
        }
        
        guard let footer = sora.sections[section].footer else {
            return nil
        }
        
        return footer
    }
    
    public func tableView(_ tableView: UITableView,
                          leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let actions = sora.sections[indexPath.section].leadingActions(at: indexPath) else { return nil }
        let config = UISwipeActionsConfiguration(actions: actions)
        return config
    }

    public func tableView(_ tableView: UITableView,
                          trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let actions = sora.sections[indexPath.section].trailingActions(at: indexPath) else { return nil }
        let config = UISwipeActionsConfiguration(actions: actions)
        return config
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.section < sora.sections.count else { return false }
        let trailingActionsEmpty = sora.sections[indexPath.section].trailingActions(at: indexPath)?.isEmpty ?? true
        let leadingActionsEmpty = sora.sections[indexPath.section].trailingActions(at: indexPath)?.isEmpty ?? true
        return !trailingActionsEmpty || !leadingActionsEmpty
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewDelegate?.scrollViewWillEndDragging?(scrollView,
                                                       withVelocity: velocity,
                                                       targetContentOffset: targetContentOffset)
    }

    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let item = sora.sections[indexPath.section].rows[indexPath.row]
        guard let actions = item.menuActions, !actions.isEmpty else { return false }
        UIMenuController.shared.menuItems = actions.map { $0.makeMenuItem() }
        UIMenuController.shared.arrowDirection = .down
        return true
    }

    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath,
                          withSender sender: Any?) -> Bool {
        let actions = sora.sections[indexPath.section].rows[indexPath.row].menuActions
        return actions?.map({ action -> Selector in action.selector }).contains(action) ?? false
    }

    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        // Нужен для работы UIMenuController
    }
    
}

extension DiffableTableView {
    
    func performWithoutScrolling(changingRows: Bool, action: () -> Void) {
        layoutIfNeeded()
        let oldOffsetY: CGFloat = contentOffset.y
        if let firstRow = sora.sections.first?.rows.first {
            let oldRect = rectForRow(at: IndexPath(row: .zero, section: .zero))
            shouldHandlePagination = false
            action()
            layoutIfNeeded()
            if let rowNewNumber = self.sora.sections.indexPath(of: firstRow) {
                let newRect = self.rectForRow(at: rowNewNumber)
                let diff = newRect.minY - oldRect.minY
                self.contentOffset.y = oldOffsetY + diff
                layoutIfNeeded()
            }
            shouldHandlePagination = true
            if changingRows {
                reloadData()
            }
        } else {
            action()
        }
    }
}
