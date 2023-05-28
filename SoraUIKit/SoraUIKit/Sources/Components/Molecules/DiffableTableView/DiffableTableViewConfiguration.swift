import UIKit

public final class DiffableTableViewConfiguration<Type: DiffableTableView>: SoramitsuScrollViewConfiguration<Type> {
    
    public typealias DataSource = UITableViewDiffableDataSource<DiffableTableViewSection, NSObject>
    typealias Snapshot = NSDiffableDataSourceSnapshot<DiffableTableViewSection, NSObject>
    
    public lazy var dataSource: DataSource = {
        DataSource(tableView: owner!) { tableView, indexPath, item in
            guard let item = item as? DiffableTableViewItemProtocol else {
                return nil
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseId(), for: indexPath)
            
            if let itemCell = cell as? DiffableTableViewCellProtocol {
                itemCell.set(item: item, context: nil)
            }
            
            return cell
        }
    }()
    
    public var sections: [DiffableTableViewSectionProtocol] = [] {
        didSet {
            registerCells()
            updateContextInSections()
            reload()
        }
    }
    
    public var context: DiffableTableViewContext? {
        didSet {
            updateContextInSections()
        }
    }
    
    public var estimatedRowHeight: CGFloat? {
        didSet {
            owner?.estimatedRowHeight = estimatedRowHeight ?? 0
        }
    }

    public var tableViewHeader: UIView? {
        didSet {
            owner?.tableHeaderView = tableViewHeader
        }
    }

    public var tableViewFooter: UIView? {
        didSet {
            owner?.tableFooterView = tableViewFooter
        }
    }
    
    public var separatorColor: SoramitsuColor? {
        didSet {
            if let separatorColor = separatorColor {
                owner?.separatorStyle = .singleLine
                owner?.separatorColor = style.palette.color(separatorColor)
            } else {
                owner?.separatorColor = nil
                owner?.separatorStyle = .none
            }
        }
    }
    
    public weak var paginationHandler: DiffableTableViewPaginationHandlerProtocol? {
        didSet {
            originalSections = nil
            updatePagination()
            owner?.updateRefreshControl()
        }
    }

    public var paginationIndicator: SoramitsuLoadingIndicatable {
        didSet {
            paginationIndicator.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    
    public var showPaginationLoaderAfterReset: Bool = false
    private var resetPaginationInProgress: Bool = false

    private var originalSections: NSRange?
    private var paginator: DiffableTableViewPaginator?
 
    override init(style: SoramitsuStyle) {
        let indicator = SoramitsuActivityIndicatorView(style: style)
        indicator.sora.useAutoresizingMask = true
        indicator.sora.backgroundColor = .bgSurface
        self.paginationIndicator = indicator
        super.init(style: style)
    }
    
    override func configureOwner() {
        super.configureOwner()
        retrigger(self, \.sections)
        retrigger(self, \.context)
        retrigger(self, \.estimatedRowHeight)
        retrigger(self, \.showsVerticalScrollIndicator)
        retrigger(self, \.tableViewHeader)
        retrigger(self, \.tableViewFooter)
        retrigger(self, \.separatorColor)
//        retrigger(self, \.handleKeyboardInset)
    }
    
    private func reload() {
        guard let sections = sections as? [DiffableTableViewSection] else {
            return
        }
        var snapshot = Snapshot()
        
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.rows, toSection: $0) }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func registerCells() {
        for section in sections {
            register(section)
        }
    }

    private func updateContextInSections() {
        sections.forEach { $0.context = context }
    }

    func register(_ items: [DiffableTableViewItemProtocol]) {
        items.forEach { self.owner?.register($0.cellType, forCellReuseIdentifier: $0.reuseId()) }
    }

    func register(_ section: DiffableTableViewSectionProtocol) {
        if let header = section.header {
            owner?.register(header.cellType, forHeaderFooterViewReuseIdentifier: header.reuseId())
        }
        register(section.rows)
    }

    public func doesHaveAnyRows() -> Bool {
        return sections.reduce(into: 0) { totalCount, section in totalCount += section.rows.count } > 0
    }
    
    public func dequeueCell(for indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        let cell = owner?.dequeueReusableCell(withIdentifier: row.reuseId(), for: indexPath)
        cell?.selectionStyle = row.isHighlighted ? .default : .none
        cell?.accessibilityLabel = row.accessibilityLabel
        cell?.accessibilityHint = row.accessibilityHint
        cell?.accessibilityIdentifier = row.accessibilityIdentifier
        cell?.accessibilityTraits = row.accessibilityTraits
        cell?.isAccessibilityElement = row.isAccessibilityElement
        cell?.accessibilityElementsHidden = row.accessibilityElementsHidden
        if let gcell = cell as? SoramitsuTableViewCell {
            gcell.sora.clipsToBounds = row.clipsToBounds
            gcell.sora.backgroundColor = row.backgroundColor
            gcell.sora.selectionColor = row.selectionColor
        }
        return cell ?? UITableViewCell()
    }

    @objc func updatePagination() {
        resetPaginationInProgress = true
        if let paginationHandler = paginationHandler {
            paginator = DiffableTableViewPaginator(handler: paginationHandler)
            paginator?.delegate = self
            paginator?.start()
        }
        if let originalSections = originalSections, let range = Range(originalSections) {
            sections = Array(sections[range])
        }
        originalSections = nil
    }
        
    public func appendPageOnTop(items: [DiffableTableViewItemProtocol], resetPages: Bool) {
        // Пересоздаем пагинатор, но не запускаем его
        if resetPages {
            if let paginationHandler = paginationHandler {
                paginator = DiffableTableViewPaginator(handler: paginationHandler)
                paginator?.delegate = self
            }
            if let originalSections = originalSections, let range = Range(originalSections) {
                sections = Array(sections[range])
            }
        }
        paginator?.appendPageOnTop(with: items)
    }

}

extension DiffableTableViewConfiguration: DiffableTableViewPaginatorDelegate {

    func reloadEmptyView() {
        owner?.reloadEmptyView()
    }

    func endRefreshing() {
        resetPaginationInProgress = false
        owner?.refreshControl?.endRefreshing()
    }

    func addLoadingIndicator(position: PagePosition) {
        if (!doesHaveAnyRows() && !showPaginationLoaderAfterReset) || resetPaginationInProgress { return }
        owner?.performWithoutScrolling(changingRows: false) {
            owner?.addLoadingIndicator(position: position)
        }
    }

    func removeLoadingIndicator(position: PagePosition) {
        owner?.removeLoadingIndicator(position: position)
    }

    func appendSections(_ sections: [DiffableTableViewSectionProtocol], position: PagePosition) {

        if originalSections == nil {
            originalSections = NSRange(location: 0, length: self.sections.count)
        }

        guard !sections.isEmpty else { return }

        switch position {
        case .bottom:
            self.sections.append(contentsOf: sections)
        case .top:
            owner?.performWithoutScrolling(changingRows: true) {
                self.sections.insert(contentsOf: sections, at: .zero)
            }
            originalSections?.location += sections.count
        }
    }

    func appendItems(_ items: [DiffableTableViewItemProtocol], position: PagePosition) {
        switch position {
        case .bottom:
            self.sections.last?.rows.append(contentsOf: items)
        case .top:
            owner?.performWithoutScrolling(changingRows: true) {
                self.sections.first?.rows.insert(contentsOf: items, at: .zero)
                self.owner?.reloadData()
            }
        }
    }

    func addItemsOnTop(_ items: [DiffableTableViewItemProtocol], position: PagePosition) {
        self.register(items)

        switch position {
        case .bottom:
            var originalSectionCount = 0
            if let originalSections = originalSections, let range = Range(originalSections) {
                originalSectionCount = range.count
            }
            self.sections.dropFirst(originalSectionCount).first?.rows.insert(contentsOf: items, at: .zero)
        case .top:
            self.sections.first?.rows.insert(contentsOf: items, at: .zero)
        }
        UIView.performWithoutAnimation {
            self.owner?.reloadData()
        }
    }

    func handlePagination(position: PagePosition) {
        paginator?.requestNextPageIfAvailable(pageType: position)
    }
}
