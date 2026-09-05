import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    self.setContentSize(NSSize(width: 1360, height: 900))
    self.minSize = NSSize(width: 440, height: 600)
    self.center()

    super.awakeFromNib()
  }
}
