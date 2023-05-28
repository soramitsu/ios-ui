import UIKit

public final class DiffableCell<Content: DiffableTableViewCellProtocol>: SoramitsuTableViewCell {

    public let content = Content()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        content.prepareForReuse()
    }

    public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        addSubview(content)
        content.pinToSuperView(respectingSafeArea: false)
    }
}

extension DiffableCell: DiffableTableViewCellProtocol {
    public func set(item: DiffableTableViewItemProtocol, context: DiffableTableViewContext?) {
        content.set(item: item, context: context)
    }
}
