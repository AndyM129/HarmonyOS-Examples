@Preview
@Entry
@Component
struct Example04_MainPage {
  @State message: string = 'Hi there';
  @State titles: Array<string> = ['one', 'two', 'three'];
  @State isListReachEnd: boolean = false;

  loadMoreArticles() {
    this.titles.push((this.titles.length + 1).toString());
  }

  build() {

    // Column() {
    //   MyComponent()
    //   Divider()
    //
    //   ForEach(this.titles, (item: string) => {
    //     MyComponent({ title: item }).margin({ top: 30 })
    //   }, (item: string) => item)
    // }.width('100%')

    Column() {
      List() {
        ForEach(this.titles, (item: string) => {
          ListItem() {
            MyComponent({ title: item }).margin({ top: 30 })
          }
        }, (item: string, index: number) => item)
      }.onReachEnd(() => {
        this.isListReachEnd = true;
      }).parallelGesture(PanGesture({ direction: PanDirection.Up, distance: 80 }).onActionStart(() => {
        if (this.isListReachEnd) {
          this.loadMoreArticles();
          this.isListReachEnd = false;
        }
      })).width('100%').height('100%')
    }.width('100%').height('100%')
  }
}


@Preview
@Component
struct MyComponent {
  @State title: string = 'Hello, MyComponent !';
  @State showSubComponent: boolean = true;

  aboutToAppear(): void {
    console.info('[MyComponent] aboutToAppear')
  }

  onDidBuild(): void {
    console.info('[MyComponent] onDidBuild')
  }

  aboutToDisappear(): void {
    console.info('[MyComponent] aboutToDisappear')
  }

  build() {
    Column() {
      Text(this.title).margin(5).onClick(() => {
        this.showSubComponent = !this.showSubComponent
      })
      if (this.showSubComponent) {
        this.subComponentBuilder()
      }
    }.width("100%")
  }

  @Builder
  subComponentBuilder() {
    Text(`Hello subComponent !`).margin(5)
  }
}

