import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { relationalStore } from '@kit.ArkData';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { DaoMaster, DaoSession, Database, GlobalContext } from '@ohos/dataorm';
import { ExampleOpenHelper } from '../examples/example_08_dataorm/ExampleOpenHelper';
import { WkDocModel } from '../examples/example_08_dataorm/WkDocModel';


const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');

    await this.setupDataorm()
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void { // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/IndexPage', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void { // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void { // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void { // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  // @ohos/dataorm 初始化
  async setupDataorm() {
    let newVersionString = '10.0.90.0'
    let newVersion = Number(newVersionString.replaceAll('.', ''));
    hilog.info(0x0000, 'dataorm', `setupDataorm - newVersion = ${newVersionString} => ${newVersion}`);

    let dbName = 'harmony_os_examples.db'
    let helper: ExampleOpenHelper = new ExampleOpenHelper(this.context, dbName);
    helper.setEncrypt(false); // 设定数据加密密钥，加密后不可变更，加密和非加密库暂不能切换
    helper.setSecurityLevel(relationalStore.SecurityLevel.S1); // 设置数据库安全等级，不设置则默认为S1
    await helper.setVersion(newVersion) // 设置新的数据库版本,如果新版本中包含表更新实例将在这调用onUpgradeDatabase进行表更新

    // 将所有的表(新增,修改,已存在)加到全局
    helper.setEntities(WkDocModel)

    // Migration为表更新实例,也可调用Migration.backupDB对当前数据库进行备份
    // let migration = new Migration("notes.db", "NOTE", newVersion).addColumn("MONEYS", ColumnType.realValue);
    // 将所有表更新实例放到ExampleOpenHelper的父级中
    // helper.setMigration(migration);

    let db: Database = await helper.getWritableDb();
    db.name = dbName;
    GlobalContext.getContext().setValue("daoSession", new DaoMaster(db).newSession());
    hilog.info(0x0000, 'dataorm', `setupDataorm - done: ${dbName}`);

    // 测试一下
    let daoSession = GlobalContext.getContext().getValue("daoSession") as DaoSession;
    hilog.info(0x0000, 'dataorm', `setupDataorm - daoSession: ${daoSession}`);
  }
}