import Foundation

public enum DiffableNextPageLoadResult {
	case loadingSuccessWithItems([DiffableTableViewItemProtocol], hasNextPage: Bool)
	case loadingSuccessWithSections([DiffableTableViewSectionProtocol], hasNextPage: Bool)
	case loadingSuccessWith(items: [DiffableTableViewItemProtocol], sections: [DiffableTableViewSectionProtocol], hasNextPage: Bool)
	case loadingFailure
}

public protocol DiffableTableViewPaginationHandlerProtocol: AnyObject {

	var paginationType: PaginationType { get }

	func didRequestNewPage(with pageNumber: UInt, completion: @escaping(DiffableNextPageLoadResult) -> Void)

	func didRequestNewPage(with pageNumber: Int, completion: @escaping(DiffableNextPageLoadResult) -> Void)

	func possibleToMakePullToRefresh() -> Bool
}

public extension DiffableTableViewPaginationHandlerProtocol {

	func didRequestNewPage(with pageNumber: Int, completion: @escaping(DiffableNextPageLoadResult) -> Void) {
		if let unsigned = pageNumber.toUInt {
			didRequestNewPage(with: unsigned, completion: completion)
		}
	}

	func didRequestNewPage(with pageNumber: UInt, completion: @escaping(DiffableNextPageLoadResult) -> Void) {}

	var paginationType: PaginationType {
		return .bottom
	}

	func possibleToMakePullToRefresh() -> Bool {
		return false
	}
}
