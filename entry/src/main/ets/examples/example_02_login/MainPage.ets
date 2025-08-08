import { router } from '@kit.ArkUI'

@Preview
@Entry
@Component
struct MainPage {
  @State title: string = 'MainPage'
  @State count: number = 0

  aboutToAppear() {
    console.info('[MainPage] aboutToAppear')
    this.count = 1
  }

  onDidBuild(): void {
    console.info('[MainPage] onDidBuild')
  }

  aboutToDisappear() {
    console.info('[MainPage] aboutToDisappear')
  }

  build() {
    Column({ space: 20 }) {
      Text(this.title).fontSize(24).fontWeight(FontWeight.Bold).textAlign(TextAlign.Center)
      Text(`当前计数：${this.count}`).fontSize(18)
      Button('增加计数').onClick(() => {
        this.count += 1
      })
      Button('back').onClick(() => {
        router.back()
      })
    }.width('100%').height('100%').padding(20)
  }
}