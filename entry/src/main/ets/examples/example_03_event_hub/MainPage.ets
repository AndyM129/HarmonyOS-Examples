import { common } from '@kit.AbilityKit';

@Preview
@Entry
@Component
struct MainPage {
  @State title: string = '使用EventHub进行数据通信'

  aboutToAppear() {
    console.info('[MainPage] aboutToAppear')
  }

  onDidBuild(): void {
    console.info('[MainPage] onDidBuild')
  }

  onPageShow(): void {
    console.info('[MainPage] onPageShow')
  }

  onBackPress(): boolean | void {
    console.info('[MainPage] onBackPress')
  }

  onPageHide(): void {
    console.info('[MainPage] onPageHide')
  }

  aboutToDisappear() {
    console.info('[MainPage] aboutToDisappear')
  }

  build() {
    Column({ space: 20 }) {
      Text(this.title).fontSize(24).fontWeight(FontWeight.Bold).textAlign(TextAlign.Center)
      Button('触发事件').onClick(() => {
        let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        context.eventHub.emit('event1', `it's data string`);
      })
      Button('添加事件的订阅').onClick(() => {
        let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        context.eventHub.on('event1', (data: string) => {
          this.getUIContext().getPromptAction().showToast({
            message: `事件被触发：${data}`
          });
        });

        this.getUIContext().getPromptAction().showToast({
          message: `已添加事件的订阅`
        });
      })
      Button('移除事件的订阅').onClick(() => {
        let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        context.eventHub.off('event1');

        this.getUIContext().getPromptAction().showToast({
          message: `已移除事件的订阅`
        });
      })

    }.width('100%').height('100%').padding(20)
  }
}