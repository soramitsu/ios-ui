import UIKit

// #codegen
final class DarkPalette: Palette {
	func color(_ color: SoramitsuColor) -> UIColor {
		switch color {
		case let .custom(uiColor): return uiColor
		
		case .fgSecondary: return Colors.grey50
		case .accentSecondary: return Colors.grey5
		case .statusSuccessContainer: return Colors.green5
		case .statusErrorContainer: return Colors.red5
		case .fgOutline: return Colors.grey60
		case .accentPrimaryContainer: return Colors.red5
		case .accentPrimary: return Colors.red40
		case .statusWarningContainer: return Colors.yellow5
		case .bgSurface: return Colors.grey80
		case .statusError: return Colors.red40
		case .statusWarning: return Colors.yellow30
		case .accentTertiary: return Colors.grey50
		case .bgSurfaceInverted: return Colors.grey5
		case .bgPage: return Colors.grey90
		case .statusInfo: return Colors.blue40
		case .additionalPolkaswap: return Colors.polkaswap40
		case .fgInverted: return Colors.grey90
		case .fgPrimary: return Colors.grey5
		case .bgSurfaceVariant: return Colors.grey70
		case .statusSuccess: return Colors.green40
		case .accentSecondaryContainer: return Colors.grey70
		case .statusInfoContainer: return Colors.blue5
		case .accentTertiaryContainer: return Colors.grey70
		case .fgTertiary: return Colors.brown30
		case .additionalPolkaswapContainer: return Colors.polkaswap5
		default: return .black
		}
	}
}