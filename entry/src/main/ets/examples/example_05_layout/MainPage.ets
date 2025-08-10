@Preview
@Entry
@Component
struct Example05_MainPage {
  @State title: string = 'MainPage'
  @State count: number = 0
  pathStack: NavPathStack = new NavPathStack();
  controller: TextInputController = new TextInputController();

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

              Button('Ok', { type: ButtonType.Normal, stateEffect: true }).borderRadius(8).width(90).height(40)

              Button({ type: ButtonType.Normal, stateEffect: true }) {
                Row() {
                  Image('https://dummyimage.com/20x20/c5c5c5/8f8f8f').width(20).height(20).margin({ left: 12 })
                  Text('loading').fontSize(12).fontColor(0xffffff).margin({ left: 5, right: 12 })
                }.alignItems(VerticalAlign.Center)
              }.borderRadius(8).backgroundColor(0x317aff).width(90).height(40)

              Button('Button', { type: ButtonType.Normal })
                .fontSize(20)
                .fontColor(Color.Pink)
                .fontWeight(500)
                .backgroundColor(0xF55A42)
                .borderRadius(10)

              Text('This is the setting of textOverflow to Clip text content This is the setting of textOverflow to None text content. This is the setting of textOverflow to Clip text content This is the setting of textOverflow to None text content.')
                .width(250)
                .maxLines(3)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)


              Text('单行输入框：')
              TextInput()
              TextInput({ placeholder: '我是提示文本' })
              TextInput({ placeholder: '我是提示文本', text: '我是当前文本内容' })
              TextInput({
                text: '', placeholder: 'input your word...', controller: this.controller
              })// .textOverflow(TextOverflow.Ellipsis)
                // .ellipsisMode(EllipsisMode.END)
                .onChange((value: string) => { // 文本内容发生变化时触发该回调
                  console.info('onChange is triggering: ', value);
                })
                .onSubmit((enterKey: EnterKeyType, event: SubmitEvent) => { // 按下输入法回车键时触发该回调
                  console.info('onSubmit is triggering: ', enterKey, event.text);
                })
                .onTextSelectionChange((selectionStart: number,
                  selectionEnd: number) => { // 文本选择的位置发生变化或编辑状态下光标位置发生变化时，触发该回调
                  console.info('onTextSelectionChange is triggering: ', selectionStart, selectionEnd);
                })
                .onSecurityStateChange((isShowPassword: boolean) => { // 密码显隐状态切换时，触发该回调
                  console.info('onSecurityStateChange is triggering: ', isShowPassword);
                })
                .onWillInsert((info: InsertValue) => { // 在将要输入时，触发该回调
                  console.info('onWillInsert is triggering: ', info.insertValue, info.insertOffset);
                  return true;
                })
                .onDidInsert((info: InsertValue) => { // 在输入完成时，触发该回调
                  console.info('onDidInsert is triggering: ', info.insertValue, info.insertOffset);
                })
                .onWillDelete((info: DeleteValue) => { // 在将要删除时，触发该回调
                  console.info('onWillDelete is triggering: ', info.deleteValue, info.deleteOffset);
                  return true;
                })
                .onDidDelete((info: DeleteValue) => { // 在删除完成时，触发该回调
                  console.info('onDidDelete is triggering: ', info.deleteValue, info.deleteOffset);
                })
                .onFocus(() => { // 绑定通用事件，输入框获焦时触发该回调
                  console.info('onFocus is triggering')
                })

              Text('多行输入框：')
              TextArea()
              TextArea({ text: "我是TextArea我是TextArea我是TextArea我是TextArea" })


            }.width('100%').padding(20)
          }.width('100%')
        }.title(this.title).width('100%')
      }
    }
  }
}