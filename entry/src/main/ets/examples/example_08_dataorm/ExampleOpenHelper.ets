// import { common } from '@kit.AbilityKit';
// import { Database, OpenHelper } from '@ohos/dataorm';
//
// export class ExampleOpenHelper extends OpenHelper {
//   constructor(context: common.UIAbilityContext, name: string, customDir?: string) {
//     super(context, name, customDir);
//   }
//
//   public async onCreateDatabase(db: Database): Promise<void> {
//     await super.onCreateDatabase(db);
//   }
//
//   async onUpgradeDatabase(db: Database, oldVersion: number, newVersion: number): Promise<void> {
//     super.onUpgradeDatabase(db, oldVersion, newVersion);
//     console.log("ExampleOpenHelper onUpgradeDatabase oldVersion:" + oldVersion + ",newVersion:" + newVersion);
//   }
//
//   async onDowngradeDatabase(db: Database, oldVersion: number, newVersion: number): Promise<void> {
//     super.onDowngradeDatabase(db, oldVersion, newVersion);
//     console.log("ExampleOpenHelper onDowngradeDatabase oldVersion:" + oldVersion + ",newVersion:" + newVersion);
//   }
// }