#!/usr/bin/swift
// Reproduce all nohasl app icons from vector paths. Run from the repository root
// on macOS: swift tools/generate_icons.swift [optional-repository-root]
import AppKit
import Foundation

let root = URL(fileURLWithPath: CommandLine.arguments.count > 1
    ? CommandLine.arguments[1] : FileManager.default.currentDirectoryPath)
let ink = CGColor(red: 21.0 / 255, green: 42.0 / 255, blue: 41.0 / 255, alpha: 1)
let lime = CGColor(red: 217.0 / 255, green: 241.0 / 255, blue: 139.0 / 255, alpha: 1)

enum IconStyle { case opaque, rounded, maskable }

func render(size: Int, style: IconStyle) throws -> Data {
    let opaque = style != .rounded
    let alpha = opaque ? CGImageAlphaInfo.noneSkipLast : .premultipliedLast
    guard let context = CGContext(
        data: nil, width: size, height: size, bitsPerComponent: 8,
        bytesPerRow: size * 4, space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: alpha.rawValue
    ) else { throw NSError(domain: "IconGenerator", code: 1) }
    context.setAllowsAntialiasing(true)
    context.setShouldAntialias(true)
    context.scaleBy(x: CGFloat(size) / 1024, y: CGFloat(size) / 1024)
    context.setFillColor(ink)
    if style == .rounded {
        context.addPath(CGPath(roundedRect: CGRect(x: 64, y: 64, width: 896, height: 896),
                               cornerWidth: 206, cornerHeight: 206, transform: nil))
        context.fillPath()
    } else {
        context.fill(CGRect(x: 0, y: 0, width: 1024, height: 1024))
    }

    // A flowing lowercase n with a gentle shoulder, readable at small sizes.
    // This is a brand mark, not an ASL sign.
    if style == .maskable {
        context.translateBy(x: 51.2, y: 51.2)
        context.scaleBy(x: 0.9, y: 0.9)
    }
    context.setStrokeColor(lime)
    context.setLineWidth(100)
    context.setLineCap(.round)
    context.setLineJoin(.round)
    context.move(to: CGPoint(x: 324, y: 326))
    context.addLine(to: CGPoint(x: 324, y: 672))
    context.strokePath()
    context.move(to: CGPoint(x: 324, y: 521))
    context.addCurve(to: CGPoint(x: 700, y: 516),
                     control1: CGPoint(x: 324, y: 730),
                     control2: CGPoint(x: 700, y: 730))
    context.addLine(to: CGPoint(x: 700, y: 326))
    context.strokePath()

    guard let image = context.makeImage(),
          let png = NSBitmapImageRep(cgImage: image).representation(using: .png, properties: [:])
    else { throw NSError(domain: "IconGenerator", code: 2) }
    return png
}

func save(_ path: String, size: Int, style: IconStyle) throws {
    let url = root.appendingPathComponent(path)
    try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
    try render(size: size, style: style).write(to: url)
}

func generateAssetCatalog(_ directory: String, style: IconStyle) throws {
    let manifest = root.appendingPathComponent(directory).appendingPathComponent("Contents.json")
    let json = try JSONSerialization.jsonObject(with: Data(contentsOf: manifest)) as! [String: Any]
    var written = Set<String>()
    for image in json["images"] as! [[String: String]] {
        guard let filename = image["filename"], written.insert(filename).inserted,
              let dimensions = image["size"], let scale = image["scale"],
              let points = Double(dimensions.components(separatedBy: "x")[0]),
              let factor = Double(scale.replacingOccurrences(of: "x", with: ""))
        else { continue }
        try save("\(directory)/\(filename)", size: Int((points * factor).rounded()), style: style)
    }
}

try generateAssetCatalog("ios/Runner/Assets.xcassets/AppIcon.appiconset", style: .opaque)
try generateAssetCatalog("macos/Runner/Assets.xcassets/AppIcon.appiconset", style: .rounded)
for (density, size) in [("mdpi", 48), ("hdpi", 72), ("xhdpi", 96), ("xxhdpi", 144), ("xxxhdpi", 192)] {
    try save("android/app/src/main/res/mipmap-\(density)/ic_launcher.png", size: size, style: .rounded)
}
for size in [192, 512] {
    try save("web/icons/Icon-\(size).png", size: size, style: .rounded)
    try save("web/icons/Icon-maskable-\(size).png", size: size, style: .maskable)
}
try save("web/favicon.png", size: 64, style: .rounded)

// Windows ICO stores one PNG for every common launcher size.
func appendLE<T: FixedWidthInteger>(_ value: T, to data: inout Data) {
    var littleEndian = value.littleEndian
    withUnsafeBytes(of: &littleEndian) { data.append(contentsOf: $0) }
}
let sizes = [16, 24, 32, 48, 64, 128, 256]
let images = try sizes.map { try render(size: $0, style: .rounded) }
var ico = Data()
appendLE(UInt16(0), to: &ico)
appendLE(UInt16(1), to: &ico)
appendLE(UInt16(sizes.count), to: &ico)
var offset = UInt32(6 + sizes.count * 16)
for (size, png) in zip(sizes, images) {
    ico.append(contentsOf: [UInt8(size == 256 ? 0 : size), UInt8(size == 256 ? 0 : size), 0, 0])
    appendLE(UInt16(1), to: &ico)
    appendLE(UInt16(32), to: &ico)
    appendLE(UInt32(png.count), to: &ico)
    appendLE(offset, to: &ico)
    offset += UInt32(png.count)
}
for png in images { ico.append(png) }
try ico.write(to: root.appendingPathComponent("windows/runner/resources/app_icon.ico"))
print("Generated nohasl icons for iOS, macOS, Android, web, and Windows.")
