// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
public typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable implicit_return

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
public enum FontFamily {
  public enum NotoSansCJKKR {
    public static let black = FontConvertible(name: "NotoSansCJKkr-Black", family: "Noto Sans CJK KR", path: "NotoSansKR-Black.otf")
    public static let demiLight = FontConvertible(name: "NotoSansCJKkr-DemiLight", family: "Noto Sans CJK KR", path: "NotoSansKR-DemiLight.otf")
    public static let light = FontConvertible(name: "NotoSansCJKkr-Light", family: "Noto Sans CJK KR", path: "NotoSansKR-Light.otf")
    public static let medium = FontConvertible(name: "NotoSansCJKkr-Medium", family: "Noto Sans CJK KR", path: "NotoSansKR-Medium.otf")
    public static let regular = FontConvertible(name: "NotoSansCJKkr-Regular", family: "Noto Sans CJK KR", path: "NotoSansKR-Regular.otf")
    public static let thin = FontConvertible(name: "NotoSansCJKkr-Thin", family: "Noto Sans CJK KR", path: "NotoSansKR-Thin.otf")
    public static let all: [FontConvertible] = [black, demiLight, light, medium, regular, thin]
  }
  public static let allCustomFonts: [FontConvertible] = [NotoSansCJKKR.all].flatMap { $0 }
  public static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

public struct FontConvertible {
  public let name: String
  public let family: String
  public let path: String

  #if os(macOS)
  public typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Font = UIFont
  #endif

  public func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  public func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

public extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
