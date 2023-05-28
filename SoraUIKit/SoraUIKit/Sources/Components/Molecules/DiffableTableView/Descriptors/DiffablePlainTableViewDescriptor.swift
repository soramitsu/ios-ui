
struct DiffablePlainTableViewDescriptor: SoramitsuElementDescriptor {

    func configure(_ element: DiffableTableView) {
        let footer = SoramitsuView(style: element.sora.style)
        footer.sora.useAutoresizingMask = true
        element.sora.tableViewFooter = footer
    }
}
