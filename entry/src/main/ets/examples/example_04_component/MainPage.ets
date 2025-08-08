
@Preview
@Entry
@Component
struct MainPage {
  @State message: string = 'Hi there';

  build() {
    Column() {
      MyComponent()
    }.width('100%')
  }
}


@Preview
@Component
struct MyComponent {
  @State title: string = 'Hello, World!';

  // @State showSubComponent: boolean = true;

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
      Text(this.title).margin(10).onClick(() => { // this.showSubComponent = !this.showSubComponent
      }) // if (this.showSubComponent) {
      this.subComponentBuilder() // }
    }.width("100%")
  }

  @Builder
  subComponentBuilder() {
    Text(`Hello subComponent`).margin(10)
  }
}

