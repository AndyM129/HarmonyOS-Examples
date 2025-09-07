import { HelloWorldPage } from 'e01_hello_world'

@Entry
@Component
struct IndexPage {
  build() {
    Column() {
      HelloWorldPage() // 仅做示意
    }
  }
}