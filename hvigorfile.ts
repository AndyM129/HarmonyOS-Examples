import { appTasks } from '@ohos/hvigor-ohos-plugin';
import { appPlugin } from "@hadss/hmrouter-plugin";

export default {

  // Built-in plugin of Hvigor. It cannot be modified.
  system: appTasks,

  // Custom plugin to extend the functionality of Hvigor.
  plugins: [appPlugin({
    ignoreModuleNames: [/** 不需要扫描的模块 **/]
  })]
}
