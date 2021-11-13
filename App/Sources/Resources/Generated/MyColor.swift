// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSColor
  public typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  public typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
public struct ColorName {
  public let rgbaValue: UInt32
  public var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#888888"></span>
  /// Alpha: 100% <br/> (0x888888ff)
  public static let _888 = ColorName(rgbaValue: 0x888888ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#d03538"></span>
  /// Alpha: 100% <br/> (0xd03538ff)
  public static let accent = ColorName(rgbaValue: 0xd03538ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f2f2f2"></span>
  /// Alpha: 100% <br/> (0xf2f2f2ff)
  public static let appMenuActionMenuBG = ColorName(rgbaValue: 0xf2f2f2ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f6f6f6"></span>
  /// Alpha: 100% <br/> (0xf6f6f6ff)
  public static let appMenuHeaderBG = ColorName(rgbaValue: 0xf6f6f6ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#9c9c9c"></span>
  /// Alpha: 100% <br/> (0x9c9c9cff)
  public static let appMenuHeaderTitle = ColorName(rgbaValue: 0x9c9c9cff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b3cffc"></span>
  /// Alpha: 100% <br/> (0xb3cffcff)
  public static let authProviderSelectedBG = ColorName(rgbaValue: 0xb3cffcff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b5b2aa"></span>
  /// Alpha: 100% <br/> (0xb5b2aaff)
  public static let cardBg = ColorName(rgbaValue: 0xb5b2aaff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#0f893d"></span>
  /// Alpha: 100% <br/> (0x0f893dff)
  public static let primary = ColorName(rgbaValue: 0x0f893dff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let components = RGBAComponents(rgbaValue: rgbaValue).normalized
    self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
  }
}

private struct RGBAComponents {
  let rgbaValue: UInt32

  private var shifts: [UInt32] {
    [
      rgbaValue >> 24, // red
      rgbaValue >> 16, // green
      rgbaValue >> 8,  // blue
      rgbaValue        // alpha
    ]
  }

  private var components: [CGFloat] {
    shifts.map {
      CGFloat($0 & 0xff)
    }
  }

  var normalized: [CGFloat] {
    components.map { $0 / 255.0 }
  }
}

public extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
