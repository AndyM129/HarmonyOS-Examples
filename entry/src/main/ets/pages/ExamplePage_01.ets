// Second.ets
// 导入页面路由模块
import { BusinessError } from '@kit.BasicServicesKit';

@Preview
@Entry
@Component
struct Example_01 {
  @State message: string = 'Hi there';

  build() {
    Row() {
      Column() {
        Text(this.message).fontSize(50).fontWeight(FontWeight.Bold)
        Button() {
          Text('Back').fontSize(30).fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('5%') // 返回按钮绑定onClick事件，单击按钮时返回到第一页
        .onClick(() => {
          console.info(`Succeeded in clicking the 'Back' button.`) // 获取UIContext
          try {
            this.getUIContext().getRouter().back()
            console.info('Succeeded in returning to the first page.')
          } catch (err) {
            console.error(`Failed to return to the first page. Code is ${(err as BusinessError).code}, message is ${(err as BusinessError).message}`)
          }
        })
      }.width('100%')
    }.height('100%')
  }
}
