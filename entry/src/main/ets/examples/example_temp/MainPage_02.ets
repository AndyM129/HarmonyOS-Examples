

@Preview
@Component
struct MyComponent {
  build() {
    TextInput({ placeholder: '密码' })
      .type(InputType.Normal)
      // .height('100%')// 去除默认圆角矩形背景
      .backgroundColor(Color.Transparent)// 如果设置InputType.Password会默认显示 眼睛打开关闭的icon
      .showPasswordIcon(false)// 可以通过下面的方法配置开关的图片 也可以不使用
      .passwordIcon({
        onIconSrc: '', offIconSrc: ''
      })
      .padding(0)// 输入文字大小颜色
      .fontSize(13)
      .fontColor(Color.White)// 光标颜色
      .caretColor('#00D3D1')// 提示文字大小颜色
      .placeholderColor(Color.White)
      .placeholderFont({ size: 10, weight: FontWeight.Lighter })
      .margin({ left: '28%', right: '15%' })// 输入回调
      .onChange((value: string) => {
        console.log(`${value}`)
      });
  }
}