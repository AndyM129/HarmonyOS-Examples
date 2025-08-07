import { BusinessError } from '@kit.BasicServicesKit';
import ExampleListItem from '../views/ExampleListItem';


@Preview
@Entry
@Component
struct Index {
  build() {
    List() {

      ExampleListItem({ title: "Hello World", subtitle: "pushUrl：pages/Example_00" }).onClick(() => {
        this.getUIContext().getRouter().pushUrl({ url: 'pages/Example_00' })
      })

      ExampleListItem({ title: "实现页面间的跳转", subtitle: "pushUrl：pages/Example_01" }).onClick(() => {
        this.getUIContext()
          .getRouter()
          .pushUrl({ url: 'pages/Example_01' })
          .then(() => {
            console.info('Succeeded in jumping to the specified page.')
          })
          .catch((err: BusinessError) => {
            console.error(`Failed to jump to the specified page. Code is ${err.code}, message is ${err.message}`)
          })
      })

    }.height('100%').width('100%').divider({ strokeWidth: 1, color: '#dddddd' })
  }
}

