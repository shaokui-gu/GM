# GM （一个用于快速开发iOS App 的脚手架）

### 开始

如何引入？

* Swift Package Manager

```
  dependencies: [
      .package(url: "https://github.com/shaokui-gu/GM.git", .upToNextMajor(from: "0.0.5"))
  ]
```
* CocoaPods

```
   pod 'GM', :git => "https://github.com/shaokui-gu/GM.git", :tag => '0.0.5'
```


### GM 主要包含以下几项个内容：

[路由](#路由)

[状态](#状态)

[生命周期](#生命周期)

[基础组件](#基础组件)
  * [Log](#log)
  * [Info](#info)
  * [Dialog](#Dialog)
  * [Toast](#Toast)
  * [Popover](#Popover)

[关于SwiftUI](#关于SwiftUI)

## <a id="路由">路由管理</a>

GM 制定了一套简洁的命名路由管理系统来管理界面跳转

```
var pages = [
        Router.RoutePage(
            name:"/",
            page: { params in
                return KKMainController()
            }
        ),
        Router.RoutePage(
            name:"/inBox",
            page: { params in
                return GMSwiftUIPage(rootView: KKMessageBoxPage())
            }
        )
        ]
```

想要使用它你首先需要:

* 如果你没有使用 SceneDelegate 你只需要在 AppDelegate 文件中

```
@main
class AppDelegate: GMAppDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GM.registerPages(AppPages.pages)
        GM.setRouterDelegate(KKRouterDelegate())
        window  = GMWindow(windowScene: windowScene)
        window!.setRootPage("/")
        window!.makeKeyAndVisible()
        
        /// others...
        
        return true
    }
}
```

* 如果你使用了 SceneDelegate 你只需要在 SceneDelegate 文件中

```
class SceneDelegate: GMSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            GM.registerPages(AppPages.pages)
            GM.setRouterDelegate(KKRouterDelegate())
            window  = GMWindow(windowScene: windowScene)
            window?.setRootPage("/")
            window!.makeKeyAndVisible()
            
            /// others...
            
        }
    }
}

```

> 注：GM 会自动为 App 创建一个 UINavigationController 作为 RootViewController, setRootPage 对应页面作为这个 navigation 的 rootViewController

* 跳转界面

```
/// push
GM.toNamed("/setting")
GM.offToNamed("/setting")

/// presentModal
GM.toModalNamed("/setting")

/// 返回上一个
GM.back()

/// 返回到根路由
GM.backTo("/")
```

## <a id="状态">状态管理</a>

GM 支持以任意 NSObject 对象作为一个状态进行管理，该对象只需要遵循 StateObjectProtocol 接口协议

```
public protocol StateObjectProtocol {
    var identifire:String { get set }
}

class CustomState : NSObject, StateObjectProtocol {
    var identifire = "custom"
    var title:String = ""
}

let state = CustomState()

/// 存储
GM.put(state)

/// 获取
let state = GM.find(CustomState.self, identifire: "custom")
state?.title = "找到了"

/// 移除
GM.popState(state)
```

## <a id="生命周期">生命周期</a>

GM 重写UIViewController 的生命周期，使用 GM后 将无法 override UIViewController 原来的生命周期

```
protocol GMPageLifeCycle {
    func onPageAppear() -> Void
    func onPageDisappear()  -> Void
    func onPageInit() -> Void
    func onPageLoaded() -> Void
    func onPageDestroy() -> Void
    func onPageBoundsUpdated(_ bounds:CGRect) -> Void
}
```
## 基础组件

## <a id="log">Log</a>

```
GM.log('hellow world')
```
## <a id="info">Info</a>

```
let version = GM.appVersion
let buildVersion = GM.buildVersion
```

## <a id="info">Info</a>

```
let windowSize = GM.windowSize
let safeArea = GM.safeArea
let deviceID = GM.deviceID
let platform = GM.platform
let osVersion = GM.osVersion
```

