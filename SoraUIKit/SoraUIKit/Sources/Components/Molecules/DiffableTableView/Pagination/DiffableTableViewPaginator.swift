
protocol DiffableTableViewPaginatorDelegate: AnyObject {

	func endRefreshing()

	func addLoadingIndicator(position: PagePosition)

	func removeLoadingIndicator(position: PagePosition)

	func appendSections(_ sections: [DiffableTableViewSectionProtocol], position: PagePosition)

	func appendItems(_ items: [DiffableTableViewItemProtocol], position: PagePosition)

	func addItemsOnTop(_ items: [DiffableTableViewItemProtocol], position: PagePosition)

	func reloadEmptyView()
}

final class DiffableTableViewPaginator {

	var delegate: DiffableTableViewPaginatorDelegate? {
		set {
			bottomPagination?.delegate = newValue
			topPagination?.delegate = newValue
		}
		get {
			return bottomPagination?.delegate
		}
	}

	private var topPagination: DiffableTableViewTopPagination?
	private var bottomPagination: DiffableTableViewBasicPagination?

	init(handler: DiffableTableViewPaginationHandlerProtocol) {
		switch handler.paginationType {
		case .both:
			bottomPagination = DiffableTableViewBasicPagination(handler: handler)
			topPagination = DiffableTableViewTopPagination(handler: handler)
		case .bottom:
			bottomPagination = DiffableTableViewBasicPagination(handler: handler)
		}
	}

	func start() {
		bottomPagination?.requestNextPage()
		topPagination?.requestNextPage()
	}

	func appendPageOnTop(with items: [DiffableTableViewItemProtocol]) {
		if topPagination != nil {
			topPagination?.appendPageOnTop(with: items)
			return
		}
		bottomPagination?.appendPageOnTop(with: items)
	}

	func requestNextPageIfAvailable(pageType: PagePosition) {
		switch pageType {
		case .bottom:
			if bottomPagination?.pageAvailable == true {
				bottomPagination?.requestNextPage()
			}
		case .top:
			if topPagination?.pageAvailable == true {
				topPagination?.requestNextPage()
			}
		}
	}
}
