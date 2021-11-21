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

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#2ec54f"></span>
  /// Alpha: 100% <br/> (0x2ec54fff)
  public static let answerCorrect = ColorName(rgbaValue: 0x2ec54fff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e6e6e6"></span>
  /// Alpha: 100% <br/> (0xe6e6e6ff)
  public static let answerNotYet = ColorName(rgbaValue: 0xe6e6e6ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cc0200"></span>
  /// Alpha: 100% <br/> (0xcc0200ff)
  public static let answerWrong = ColorName(rgbaValue: 0xcc0200ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b3cffc"></span>
  /// Alpha: 100% <br/> (0xb3cffcff)
  public static let dropdownSelected = ColorName(rgbaValue: 0xb3cffcff)
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
