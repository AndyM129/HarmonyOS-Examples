import { BusinessError } from '@kit.BasicServicesKit';
import ExampleListItem from '../views/ExampleListItem';


@Preview
@Entry
@Component
struct Index {
  build() {
    List() {

      ExampleListItem({ title: "Hello World", subtitle: "pushUrl：examples/example_00/MainPage" }).onClick(() => {
        this.getUIContext().getRouter().pushUrl({ url: 'examples/example_00/MainPage' })
      })

      ExampleListItem({ title: "实现页面间的跳转", subtitle: "pushUrl：examples/example_01/MainPage" }).onClick(() => {
        this.getUIContext()
          .getRouter()
          .pushUrl({ url: 'examples/example_01/MainPage' })
          .then(() => {
            console.info('Succeeded in jumping to the specified page.')
          })
          .catch((err: BusinessError) => {
            console.error(`Failed to jump to the specified page. Code is ${err.code}, message is ${err.message}`)
          })
      })

      ExampleListItem({ title: "登录页", subtitle: "pushUrl：examples/example_02_login/MainPage" }).onClick(() => {
        this.getUIContext().getRouter().pushUrl({ url: 'examples/example_02_login/MainPage' })
      })

      ExampleListItem({ title: "使用EventHub进行数据通信", subtitle: "pushUrl：examples/example_03_event_hub/MainPage" }).onClick(() => {
        this.getUIContext().getRouter().pushUrl({ url: 'examples/example_03_event_hub/MainPage' })
      })

      ExampleListItem({ title: "自定义组件", subtitle: "pushUrl：examples/example_04_component/MainPage" }).onClick(() => {
        this.getUIContext().getRouter().pushUrl({ url: 'examples/example_04_component/MainPage' })
      })

      ExampleListItem({ title: "布局", subtitle: "pushUrl：examples/example_05_layout/MainPage" }).onClick(() => {
        this.getUIContext().getRouter().pushUrl({ url: 'examples/example_05_layout/MainPage' })
      })

      ExampleListItem({ title: "临时测试", subtitle: "pushUrl：examples/example_temp/MainPage" }).onClick(() => {
        this.getUIContext().getRouter().pushUrl({ url: 'examples/example_temp/MainPage' })
      })

    }.height('100%').width('100%').divider({ strokeWidth: 1, color: '#dddddd' })
  }
}

