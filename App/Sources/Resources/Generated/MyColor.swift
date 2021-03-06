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

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#222222"></span>
  /// Alpha: 100% <br/> (0x222222ff)
  public static let _222 = ColorName(rgbaValue: 0x222222ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#555555"></span>
  /// Alpha: 100% <br/> (0x555555ff)
  public static let _555 = ColorName(rgbaValue: 0x555555ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#888888"></span>
  /// Alpha: 100% <br/> (0x888888ff)
  public static let _888 = ColorName(rgbaValue: 0x888888ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#39a5c6"></span>
  /// Alpha: 100% <br/> (0x39a5c6ff)
  public static let acc2 = ColorName(rgbaValue: 0x39a5c6ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff6666"></span>
  /// Alpha: 100% <br/> (0xff6666ff)
  public static let acc4 = ColorName(rgbaValue: 0xff6666ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#bbbbbb"></span>
  /// Alpha: 100% <br/> (0xbbbbbbff)
  public static let bbb = ColorName(rgbaValue: 0xbbbbbbff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cccccc"></span>
  /// Alpha: 100% <br/> (0xccccccff)
  public static let ccc = ColorName(rgbaValue: 0xccccccff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#d4d4d4"></span>
  /// Alpha: 100% <br/> (0xd4d4d4ff)
  public static let d4 = ColorName(rgbaValue: 0xd4d4d4ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e5e5e5"></span>
  /// Alpha: 100% <br/> (0xe5e5e5ff)
  public static let e5 = ColorName(rgbaValue: 0xe5e5e5ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#dd2222"></span>
  /// Alpha: 100% <br/> (0xdd2222ff)
  public static let negative = ColorName(rgbaValue: 0xdd2222ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#654cbf"></span>
  /// Alpha: 100% <br/> (0x654cbfff)
  public static let primary = ColorName(rgbaValue: 0x654cbfff)
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
