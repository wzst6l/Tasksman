import Task from '../model/Task';
import Tasks from '../model/Tasks';
import { CommonConstants } from '../common/constant/CommonConstant';
import currentTime from '../common/utils/DateLocal';
import { promptAction } from '@kit.ArkUI';
import { AddTask } from './AddTask'
import { TaskPrerview } from './TaskPrerview'
import { TaskList } from './TaskList'

@Entry
@Component
struct Home {
  @State tasks: Task[] = Tasks.allData
  @State total: number = 0
  @State finish: number = 0
  @State latestUpdate: string = CommonConstants.DEFAULT_PROGRESS_VALUE
  @Provide @Watch('onProgressChanged') totalProgressChanged: boolean = false

  // 当总进度发生变化时
  onProgressChanged() {
    this.total = this.tasks.length
    this.finish = this.tasks.filter(task => {
      return task.progress == CommonConstants.SLIDER_MAX_VALUE
    }).length
    this.latestUpdate = currentTime()
  }

  //保存新增的任务
  saveTask(name: string, typeIndex?: number) {
    if (name == '') {
      promptAction.showToast({
        message: $r('app.string.cannot_input_empty'),
        duration: CommonConstants.TOAST_TIME,
        bottom: CommonConstants.TOAST_MARGIN_BOTTOM
      })
      return
    }
    Tasks.add(new Task(name, currentTime(), 0, typeIndex))
    this.tasks = Tasks.allData
    this.totalProgressChanged = !this.totalProgressChanged
    this.dialogController.close()
  }

  // 新增任务的对话框控制器
  dialogController = new CustomDialogController({
    builder: AddTask({
      onConfirm: (value: string, typeIndex?: number) => {
        this.saveTask(value, typeIndex)
      }
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: false, // 不自动取消
    offset: { dx: CommonConstants.DIALOG_OFFSET_X, dy: $r('app.float.dialog_offset_y') }
  })

  @Builder
  titleBar() {
    Text($r('app.string.title'))
      .width(CommonConstants.TITLE_WIDTH)
      .height($r('app.float.title_height'))
      .fontSize($r('app.float.title_font'))
      .fontWeight(CommonConstants.FONT_WEIGHT)
      .textAlign(TextAlign.Start)
      .margin({
        top: $r('app.float.title_margin'),
        bottom: $r('app.float.title_margin')
      })



  }

  build() {
    Column() {
      this.titleBar()

      TaskPrerview({
        latestUpdate: this.latestUpdate,
        total: this.total,
        finish: this.finish
      })

      TaskList({
        tasks: this.tasks,
        onAddClick:():void=> this.dialogController.open()
      })
        .height('53%')

    }
    .height(CommonConstants.FULL_HEIGHT)
    .width(CommonConstants.FULL_WIDTH)
    .backgroundColor($r('app.color.index_background'))
  }
}