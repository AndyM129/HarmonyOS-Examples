// export class Example08_MainPageDataSource<T> implements IDataSource {
//   items: T[] = []
//
//   constructor(items?: T[]) {
//     this.items = items ?? []
//   }
//
//   totalCount(): number {
//     return this.items.length;
//   }
//
//   getData(index: number): T | null {
//     return this.items[index];
//   }
//
//   // 添加数据
//   public push(item: T): void {
//     this.items.push(item);
//     this.notifyDataAdd(this.dataArray.length - 1);
//   }
//
//   registerDataChangeListener(listener: DataChangeListener): void {
//
//   }
//
//   unregisterDataChangeListener(listener: DataChangeListener): void {
//
//   }
// }

// export class Example08_MainPageDataSource<T> implements IDataSource {
//   constructor(itemsGetter: () => T[] | null) {
//     this.itemsGetter = itemsGetter
//   }
//
//   totalCount(): number {
//     let items = this.itemsGetter()
//     return items?.length ?? 0;
//   }
//
//   getData(index: number): T | null {
//     let items = this.itemsGetter()
//     return items ? items[index] : null;
//   }
//
//   registerDataChangeListener(listener: DataChangeListener): void {
//
//   }
//
//   unregisterDataChangeListener(listener: DataChangeListener): void {
//
//   }
//
//   private itemsGetter: () => T[] | null = () => null
// }