
final class DiffableTableViewTopPagination: DiffableTableViewBasicPagination {

	private let initialPage = -1

	override init(handler: DiffableTableViewPaginationHandlerProtocol) {
		super.init(handler: handler)
		pageNumber = initialPage
		pagePosition  = .top
	}

	override func incrementPage() {
		pageNumber -= 1
	}

	override func isFirstPage() -> Bool {
		return pageNumber == initialPage
	}
}
