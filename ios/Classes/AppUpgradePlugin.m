#import "AppUpgradePlugin.h"
#if __has_include(<app_upgrade/app_upgrade-Swift.h>)
#import <app_upgrade/app_upgrade-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "app_upgrade-Swift.h"
#endif

@implementation AppUpgradePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppUpgradePlugin registerWithRegistrar:registrar];
}
@end
