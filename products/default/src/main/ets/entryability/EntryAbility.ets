import { hilogx } from '@andym129/hilogx'
import { HMRouterMgr } from '@hadss/hmrouter'
import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit'
import { JSON } from '@kit.ArkTS'
import { window } from '@kit.ArkUI'
import { BusinessError } from '@kit.BasicServicesKit'

// UIAbility组件生命周期，详见 https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/uiability-lifecycle
export default class EntryAbility extends UIAbility {
  constructor() {
    super()
    this.setupHilogx()
  }

  // 在首次创建UIAbility实例时，系统触发onCreate()回调。开发者可以在该回调中执行UIAbility整个生命周期中仅发生一次的启动逻辑。
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilogx.info(`EntryAbility onCreate: begin => ${JSON.stringify({
      'want': want, 'launchParam': launchParam
    })}`)
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
    this.setupHMRouter()
    hilogx.info('EntryAbility onCreate: end')
  }

  // UIAbility实例创建完成之后，在进入前台之前，系统会创建一个WindowStage。WindowStage创建完成后会进入onWindowStageCreate()回调，开发者可以在该回调中进行UI加载、WindowStage的事件订阅。
  // 在onWindowStageCreate()回调中通过loadContent()方法设置应用要加载的页面，并根据需要调用on('windowStageEvent')方法订阅WindowStage的事件（获焦/失焦、切到前台/切到后台、前台可交互/前台不可交互）。
  onWindowStageCreate(windowStage: window.WindowStage): void { // Main window is created, set main page for this ability
    hilogx.info('Ability onWindowStageCreate: begin')
    AppStorage.setOrCreate('windowStage', windowStage);
    AppStorage.setOrCreate('window', windowStage.getMainWindowSync())

    // 设置WindowStage的事件订阅（获焦/失焦、切到前台/切到后台、前台可交互/前台不可交互）
    try {
      windowStage.on('windowStageEvent', this.onWindowStageEvent)
    } catch (exception) {
      hilogx.error(`Failed to enable the listener for window stage event changes. Cause: ${JSON.stringify(exception)}`);
    }

    // 设置UI加载
    windowStage.loadContent('pages/IndexPage', this.onWindowStageLoadContent)
    hilogx.info('Ability onWindowStageCreate: end')
  }

  // Ability has brought to foreground
  // 在UIAbility切换至前台时且UIAbility的UI可见之前，系统触发onForeground回调。
  // 开发者可以在该回调中申请系统需要的资源，或者重新申请在onBackground()中释放的资源。
  // 系统回调该方法后，UIAbility实例进入前台状态，即UIAbility实例可以与用户交互的状态。
  // UIAbility实例会一直处于这个状态，直到被某些动作打断（例如屏幕关闭、用户跳转到其他UIAbility）。
  onForeground(): void {
    hilogx.info('Ability onForeground')
  }

  // WindowStage的事件订阅（获焦/失焦、切到前台/切到后台、前台可交互/前台不可交互）
  onWindowStageEvent(stageEventType: window.WindowStageEventType) {
    switch (stageEventType) {
      case window.WindowStageEventType.SHOWN: // 切到前台
        hilogx.info(`windowStage foreground.`);
        break;
      case window.WindowStageEventType.ACTIVE: // 获焦状态
        hilogx.info(`windowStage active.`);
        break;
      case window.WindowStageEventType.INACTIVE: // 失焦状态
        hilogx.info(`windowStage inactive.`);
        break;
      case window.WindowStageEventType.HIDDEN: // 切到后台
        hilogx.info(`windowStage background.`);
        break;
      case window.WindowStageEventType.RESUMED: // 前台可交互状态
        hilogx.info(`windowStage resumed.`);
        break;
      case window.WindowStageEventType.PAUSED: // 前台不可交互状态
        hilogx.info(`windowStage paused.`);
        break;
      default:
        break;
    }
  }

  onWindowStageLoadContent(err: BusinessError<void>) {
    if (err.code) {
      hilogx.error('windowStage.loadContent: failed => %{public}s', JSON.stringify(err))
      return
    }
    hilogx.info('windowStage.loadContent: succeeded')
  }

  // Ability has back to background
  // 在UIAbility的UI完全不可见之后，系统触发onBackground回调，将UIAbility实例切换至后台状态。
  // 开发者可以在该回调中释放UI不可见时的无用资源，例如停止定位功能，以节省系统的资源消耗。
  // onBackground()执行时间较短，无法提供足够的时间做一些耗时动作。
  // 请勿在该方法中执行保存用户数据或执行数据库事务等耗时操作。
  onBackground(): void {
    hilogx.info('Ability onBackground')
  }

  // 当应用的UIAbility实例已创建，再次调用方法启动该UIAbility实例时，系统触发该UIAbility的onNewWant()回调。
  // 开发者可以在该回调中更新要加载的资源和数据等，用于后续的UI展示。
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilogx.info('Ability onNewWant')
  }

  // 在UIAbility实例销毁之前，系统触发onWindowStageWillDestroy()回调。
  // 该回调在WindowStage销毁前执行，此时WindowStage可以使用。
  // 开发者可以在该回调中释放通过WindowStage获取的资源、注销WindowStage事件订阅等。
  onWindowStageWillDestroy(windowStage: window.WindowStage) {
    try {
      windowStage.off('windowStageEvent');
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilogx.error(`Failed to disable the listener for windowStageEvent. Code is ${code}, message is ${message}`);
    }
  }

  // Main window is destroyed, release UI related resources
  // 在UIAbility实例销毁之前，系统触发onWindowStageDestroy()回调，开发者可以在该回调中释放UI资源。
  // 该回调在WindowStage销毁后执行，此时WindowStage不可以使用。
  onWindowStageDestroy(): void {
    hilogx.info('Ability onWindowStageDestroy')
  }

  // 在UIAbility实例销毁之前，系统触发onDestroy回调。
  // 该回调是UIAbility接收到的最后一个生命周期回调，开发者可以在onDestroy()回调中进行系统资源的释放、数据的保存等操作。
  onDestroy(): void {
    hilogx.info('Ability onDestroy')
  }

  setupHilogx() {
    hilogx.info('hilogx setup: begin')
    hilogx.defaultDomain = 0xA129
    hilogx.defaultTag = 'HOS-Examples-APP'
    hilogx.setMinLogLevel(hilogx.LogLevel.DEBUG)
    hilogx.info('hilogx setup: end')
  }

  setupHMRouter() {
    hilogx.info('HMRouterMgr setup: begin')
    HMRouterMgr.openLog("DEBUG") // 日志开启需在init之前调用，否则会丢失初始化日志
    HMRouterMgr.init({
      context: this.context
    })
    hilogx.info('HMRouterMgr setup: end')
  }
}