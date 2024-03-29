import Foundation
import UIKit

public final class HistoryTransactionView: UIControl, Molecule {

    public let sora: HistoryTransactionViewConfiguration<HistoryTransactionView>
    public var isRightToLeft: Bool = false {
        didSet {
            setupSemantics()
        }
    }

    // MARK: - UI

    var firstCurrencyHeightContstaint: NSLayoutConstraint?
    
    public let currenciesView: SoramitsuView = {
        let view = SoramitsuView()
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()

    public let firstCurrencyImageView: SoramitsuImageView = {
        let view = SoramitsuImageView()
        view.sora.loadingPlaceholder.type = .shimmer
        view.sora.loadingPlaceholder.shimmerview.sora.cornerRadius = .circle
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        return view
    }()

    public let secondCurrencyImageView: SoramitsuImageView = {
        let view = SoramitsuImageView()
        view.sora.loadingPlaceholder.type = .shimmer
        view.sora.loadingPlaceholder.shimmerview.sora.cornerRadius = .circle
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 28).isActive = true
        view.widthAnchor.constraint(equalToConstant: 28).isActive = true
        view.isHidden = true
        return view
    }()
    
    public let oneCurrencyImageView: SoramitsuImageView = {
        let view = SoramitsuImageView()
        view.sora.loadingPlaceholder.type = .shimmer
        view.sora.loadingPlaceholder.shimmerview.sora.cornerRadius = .circle
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        view.widthAnchor.constraint(equalToConstant: 32).isActive = true
        return view
    }()
    
    public let transactionTypeView: SoramitsuView = {
        let view = SoramitsuView()
        view.sora.backgroundColor = .bgSurface
        view.sora.shadow = .small
        view.sora.cornerRadius = .custom(8)
        view.sora.tintColor = .fgSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        view.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()
    
    public let transactionTypeImageView: SoramitsuImageView = {
        let view = SoramitsuImageView()
        view.sora.backgroundColor = .bgSurface
        view.sora.shadow = .small
        view.sora.tintColor = .fgSecondary
        view.sora.loadingPlaceholder.type = .shimmer
        view.sora.loadingPlaceholder.shimmerview.sora.cornerRadius = .circle
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 12).isActive = true
        view.widthAnchor.constraint(equalToConstant: 12).isActive = true
        return view
    }()

    public let titleLabel: SoramitsuLabel = {
        let label = SoramitsuLabel()
        label.sora.font = FontType.textM
        label.sora.textColor = .fgPrimary
        label.sora.loadingPlaceholder.type = .shimmer
        label.sora.loadingPlaceholder.shimmerview.sora.cornerRadius = .circle
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    public let subtitleLabel: SoramitsuLabel = {
        let label = SoramitsuLabel()
        label.sora.font = FontType.textBoldXS
        label.sora.textColor = .fgSecondary
        label.sora.loadingPlaceholder.type = .shimmer
        label.sora.loadingPlaceholder.shimmerview.sora.cornerRadius = .circle
        return label
    }()
    
    private let amountStackView: SoramitsuStackView = {
        var view = SoramitsuStackView()
        view.sora.axis = .horizontal
        view.sora.distribution = .fill
        view.spacing = 4
        return view
    }()

    public let amountUpLabel: SoramitsuLabel = {
        let label = SoramitsuLabel()
        label.sora.font = FontType.textM
        label.sora.textColor = .fgPrimary
        label.sora.alignment = .right
        label.sora.loadingPlaceholder.type = .shimmer
        label.sora.loadingPlaceholder.shimmerview.sora.cornerRadius = .circle
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    public let statusImageView: SoramitsuImageView = {
        let view = SoramitsuImageView()
        view.sora.isHidden = true
        view.sora.loadingPlaceholder.type = .shimmer
        view.sora.loadingPlaceholder.shimmerview.sora.cornerRadius = .circle
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        view.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()

    public let fiatLabel: SoramitsuLabel = {
        let label = SoramitsuLabel()
        label.sora.font = FontType.textBoldXS
        label.sora.textColor = .fgSecondary
        label.sora.alignment = .right
        label.sora.loadingPlaceholder.type = .shimmer
        label.sora.loadingPlaceholder.shimmerview.sora.cornerRadius = .circle
        return label
    }()

    private var type: HistoryTransactionViewType

    init(style: SoramitsuStyle, type: HistoryTransactionViewType = .asset) {
        sora = HistoryTransactionViewConfiguration(style: style, type: type)
        self.type = type
        super.init(frame: .zero)
        sora.owner = self
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HistoryTransactionView {
    func setup() {
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false

        amountStackView.addArrangedSubviews([amountUpLabel, statusImageView])
        addSubviews(currenciesView, titleLabel, subtitleLabel, amountStackView)
        
        transactionTypeView.addSubview(transactionTypeImageView)

        currenciesView.addSubview(firstCurrencyImageView)
        currenciesView.addSubview(secondCurrencyImageView)
        currenciesView.addSubview(oneCurrencyImageView)
        currenciesView.addSubview(transactionTypeView)

        firstCurrencyHeightContstaint = firstCurrencyImageView.heightAnchor.constraint(equalToConstant: 28)
        firstCurrencyHeightContstaint?.isActive = true
        
        NSLayoutConstraint.activate([
            firstCurrencyImageView.leadingAnchor.constraint(equalTo: currenciesView.leadingAnchor),
            firstCurrencyImageView.topAnchor.constraint(equalTo: currenciesView.topAnchor),

            secondCurrencyImageView.trailingAnchor.constraint(equalTo: currenciesView.trailingAnchor),
            secondCurrencyImageView.bottomAnchor.constraint(equalTo: currenciesView.bottomAnchor),
            
            oneCurrencyImageView.centerXAnchor.constraint(equalTo: currenciesView.centerXAnchor),
            oneCurrencyImageView.centerYAnchor.constraint(equalTo: currenciesView.centerYAnchor),
            
            transactionTypeView.leadingAnchor.constraint(equalTo: currenciesView.leadingAnchor),
            transactionTypeView.bottomAnchor.constraint(equalTo: currenciesView.bottomAnchor),
            
            transactionTypeImageView.centerXAnchor.constraint(equalTo: transactionTypeView.centerXAnchor),
            transactionTypeImageView.centerYAnchor.constraint(equalTo: transactionTypeView.centerYAnchor),
            
            currenciesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            currenciesView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            currenciesView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: currenciesView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: currenciesView.topAnchor, constant: 2),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: currenciesView.trailingAnchor, constant: 8),
            subtitleLabel.bottomAnchor.constraint(equalTo: currenciesView.bottomAnchor, constant: -2),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            amountStackView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            amountStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            amountStackView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            amountStackView.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor),
        ])
    }
    
    private func setupSemantics() {
        let alignment: NSTextAlignment = isRightToLeft ? .right : .left
        titleLabel.sora.alignment = alignment
        subtitleLabel.sora.alignment = alignment
    }
}

public extension HistoryTransactionView {

    convenience init(type: HistoryTransactionViewType = .asset) {
        let sora = SoramitsuUI.shared
        self.init(style: sora.style, type: type)
    }
}
