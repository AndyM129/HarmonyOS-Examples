@Preview
@Entry
@Component
struct MainPage {
  @State title: string = 'MainPage'
  @State count: number = 0

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
    Column() {
      Navigation() {
        NavDestination() {
          Divider()
          Scroll() {
            Column({ space: 20 }) {
              Text(`当前计数：${this.count}`).fontSize(18)
              Button('增加计数').onClick(() => {
                this.count += 1
              })
            }.width('100%').padding({ top: 20 })
          }.width('100%')
        }.title(this.title).width('100%')
      }
    }
  }
}