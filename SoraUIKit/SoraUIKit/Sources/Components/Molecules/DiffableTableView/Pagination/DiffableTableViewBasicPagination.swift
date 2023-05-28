class DiffableTableViewBasicPagination {

	private struct Consts {
		static let firstPage = 0
	}

	weak var delegate: DiffableTableViewPaginatorDelegate?
	weak var handler: DiffableTableViewPaginationHandlerProtocol?

	var pageNumber = Consts.firstPage
	var pagePosition: PagePosition = .bottom
	var pageAvailable = false

	init(handler: DiffableTableViewPaginationHandlerProtocol) {
		self.handler = handler
	}

	func requestNextPage() {
		delegate?.addLoadingIndicator(position: pagePosition)
		pageAvailable = false
		handler?.didRequestNewPage(with: pageNumber) { [weak self] result in
			DispatchQueue.mainAsyncIfNeeded {
				self?.handlePagingResponse(result)
			}
		}
	}

	func incrementPage() {
		pageNumber += 1
	}

	func isFirstPage() -> Bool {
		return pageNumber == Consts.firstPage
	}

	func appendPageOnTop(with items: [DiffableTableViewItemProtocol]) {
		if isFirstPage() {
			pageAvailable = true
			delegate?.appendSections([DiffableTableViewSection(rows: items)], position: pagePosition)
		} else {
			delegate?.addItemsOnTop(items, position: pagePosition)
		}
		incrementPage()
	}

	private func handlePagingResponse(_ result: DiffableNextPageLoadResult) {
        delegate?.endRefreshing()
		switch result {
		case let .loadingSuccessWithSections(sections, hasNextPage):
			if sections.isEmpty {
				pageAvailable = false
				delegate?.reloadEmptyView()
			} else {
				pageAvailable = hasNextPage
				delegate?.appendSections(sections, position: pagePosition)
				incrementPage()
			}
		case let .loadingSuccessWithItems(items, hasNextPage):
			if items.isEmpty {
				pageAvailable = false
				delegate?.reloadEmptyView()
			} else {
				pageAvailable = hasNextPage
				appendItems(items)
				incrementPage()
			}
		case let .loadingSuccessWith(items: items, sections: sections, hasNextPage: hasNextPage):
			if sections.isEmpty && items.isEmpty {
				pageAvailable = false
				delegate?.reloadEmptyView()
			} else {
				pageAvailable = hasNextPage
				appendItems(items)
				delegate?.appendSections(sections, position: pagePosition)
				incrementPage()
			}
		case .loadingFailure:
			pageAvailable = true
		}
		delegate?.removeLoadingIndicator(position: pagePosition)
	}

	private func appendItems(_ items: [DiffableTableViewItemProtocol]) {
		if isFirstPage() {
			delegate?.appendSections([DiffableTableViewSection(rows: items)], position: pagePosition)
		} else {
			delegate?.appendItems(items, position: pagePosition)
		}
	}
}
