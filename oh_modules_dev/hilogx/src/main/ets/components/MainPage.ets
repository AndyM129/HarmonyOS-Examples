import { hilog } from '@kit.PerformanceAnalysisKit';

@Component
export struct MainPage {
  @State message: string = 'Hello hilogx';

  build() {
    Row() {
      Column() {
        Text(this.message).fontSize($r('app.float.page_text_font_size')).fontWeight(FontWeight.Bold).onClick(() => {
          this.message = 'Welcome';
        })

        Button('Click to hilog').backgroundColor('#438DE3').margin({ top: 20 }).onClick(() => {
          const DOMAIN = 0xFF00 // DOMAIN 自定义的日志域，范围 0x0 - 0xFFFF，建议为项目分配一个固定值，方便过滤
          const TAG = "hilogx-example-app" // 日志标签，方便过滤

          hilog.debug(DOMAIN, TAG, "调试日志 message=%{public}s", "hello debug")
          hilog.info(DOMAIN, TAG, "普通信息日志 message=%{public}s", "hello info")
          hilog.warn(DOMAIN, TAG, "警告日志 message=%{public}s", "hello warn")
          hilog.error(DOMAIN, TAG, "错误日志 message=%{public}s", "hello error")
          hilog.fatal(DOMAIN, TAG, "严重错误日志 message=%{public}s", "hello fatal")

          this.getUIContext().getPromptAction().showToast({
            message: '请看下控制台输出~'
          });
        })

        Button('Click to hilogx').backgroundColor('#5FCD72').margin({ top: 20 }).onClick(() => {
          // const DOMAIN = 0xFF00 // DOMAIN 自定义的日志域，范围 0x0 - 0xFFFF，建议为项目分配一个固定值，方便过滤
          // const TAG = "hilogx-example-app" // 日志标签，方便过滤
          //
          // hilogx.debug(DOMAIN, TAG, "调试日志 message=%{public}s", "hello debug")
          // hilogx.info(DOMAIN, TAG, "普通信息日志 message=%{public}s", "hello info")
          // hilogx.warn(DOMAIN, TAG, "警告日志 message=%{public}s", "hello warn")
          // hilogx.error(DOMAIN, TAG, "错误日志 message=%{public}s", "hello error")
          // hilogx.fatal(DOMAIN, TAG, "严重错误日志 message=%{public}s", "hello fatal")

          this.getUIContext().getPromptAction().showToast({
            message: '待开发...'
          });
        })
      }.width('100%')
    }.height('100%')
  }
}
