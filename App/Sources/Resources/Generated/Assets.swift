// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public static let accountCircle = ImageAsset(name: "account_circle")
  public static let apple = ImageAsset(name: "apple")
  public static let arrowBack = ImageAsset(name: "arrow_back")
  public static let close = ImageAsset(name: "close")
  public static let correct = ImageAsset(name: "correct")
  public static let dropdownMenuAll = ImageAsset(name: "dropdown_menu_all")
  public static let email = ImageAsset(name: "email")
  public static let filterList = ImageAsset(name: "filter_list")
  public static let floatingInfomation = ImageAsset(name: "floating_infomation")
  public static let github = ImageAsset(name: "github")
  public static let google = ImageAsset(name: "google")
  public static let incorrect = ImageAsset(name: "incorrect")
  public static let joinIcon = ImageAsset(name: "join_icon")
  public static let launchTetris = ImageAsset(name: "launch_tetris")
  public static let logout = ImageAsset(name: "logout")
  public static let moreVert = ImageAsset(name: "more_vert")
  public static let star = ImageAsset(name: "star")
  public static let starBorder = ImageAsset(name: "star_border")
  public static let tabBookmark = ImageAsset(name: "tab_bookmark")
  public static let tabHome = ImageAsset(name: "tab_home")
  public static let tabMenu = ImageAsset(name: "tab_menu")
  public static let tabSearch = ImageAsset(name: "tab_search")
  public static let tag = ImageAsset(name: "tag")
  public static let thumbUp = ImageAsset(name: "thumb_up")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

public extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
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
