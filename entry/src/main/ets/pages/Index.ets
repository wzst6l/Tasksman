import Logger from '../common/utils/Logger'
import currentTime from "../common/utils/DateLocal";
import {AddTask} from './AddTask'

@Entry
@Component
struct Index {
  @State message: string = '添加任务';

  dialogController = new CustomDialogController({
    builder: AddTask({
      onConfirm: (value: string) => {Logger.debug('首页添加任务：', value)}
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: false,
    offset:{dx: 0, dy:-20}
  })

  build() {
    Row() {
      Column(){
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() =>{
            Logger.debug('首页', currentTime())
            this.dialogController.open()
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}