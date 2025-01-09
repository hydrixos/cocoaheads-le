import SwiftUI

extension Note.Color {
	var color: SwiftUI.Color {
		switch self {
		case .default: SwiftUI.Color(.labelColor)
		case .red: SwiftUI.Color.red
		case .green: SwiftUI.Color.green
		case .blue: SwiftUI.Color.blue
		}
	}
}
