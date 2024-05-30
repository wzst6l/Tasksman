import { CommonConstants } from '../common/constant/CommonConstant';
import currentTime from '../common/utils/DateLocal';
import Task from '../model/Task';
import Tasks from '../model/Tasks';
import { ProgressEdit } from './ProgressEdit'
import { promptAction } from '@kit.ArkUI';


@Component
export struct TaskItem {
  @State task: Task = new Task('task 1', currentTime(), 10)
  index = 0 //当前任务序号
  @Consume totalProgressChanged: boolean  // = false // 总进度是否发生变化
  @Link selectedTasks: boolean[] // 选中的任务
  @Prop isEdit: boolean
  @State isExpand: boolean = false // 是否展开面板
  @State mode: number = CommonConstants.DEFAULT_SLIDER_MODE // 进度面板滑动模式
  @Link @Watch('onClickIndex') clickIndex: number

  // 索引点击监听，如果不是当前索引，则折叠进度面板
  onClickIndex() {
    if (this.clickIndex != this.index) {
      this.isExpand = false
    }
  }

  //最新的进度值
  @State latestProgress: number = 0
  // 更新时间
  @State updateDate?: string = ''

  // 页面即将显示时
  aboutToAppear(): void {
    this.latestProgress = this.task.progress
    this.updateDate = this.task.update
   // Tasks.add(this.task)
  }

  @Builder
  TaskInfo() {
    Row() {
      Text(this.task.name)
        .subTitleStyle()
        .textAlign(TextAlign.Start)
        .width(CommonConstants.TASK_NAME_WIDTH)
        .maxLines(CommonConstants.MAX_LINES)

      Blank()
      Column() {
        Text(`${this.task.progress}%`)
          .subTitleStyle()
        Row() {
          Text($r('app.string.latest_updateTime')).opacityTextStyle()
          Text(this.task.update).opacityTextStyle()
        }

      }.alignItems(HorizontalAlign.End)
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Column() {
        this.TaskInfo()
        if (this.isExpand) {
          Blank()
          ProgressEdit({
            progress: this.latestProgress,
            mode: this.mode,
            onCancel: () => {
              this.isExpand = false
            },
            onConfirm: (value) => {
              this.latestProgress = value
              this.updateDate = currentTime()
              // 指定索引更新任务
              if (Tasks.updateTask(this.clickIndex, this.latestProgress, this.updateDate)) {
                this.totalProgressChanged = !this.totalProgressChanged
                this.task = Tasks.allData[this.clickIndex]
                if(this.task.progress == CommonConstants.SLIDER_MAX_VALUE && this.task.typeIndex != undefined && CommonConstants.TASK_TYPES[this.task.typeIndex] != undefined){
                  promptAction.showToast({
                    message: CommonConstants.TASK_TYPES[this.task.typeIndex] + '+1~',
                    duration: CommonConstants.TOAST_TIME,
                    offset: { dx: 10, dy: -10}
                  })
                }

              }
              this.isExpand = false
            }
          }).transition({
            //折叠动画
            scale: {
              x: CommonConstants.TRANSITION_ANIMATION_X,
              y: CommonConstants.TRANSITION_ANIMATION_Y,
            }
          })
        }
      }
      .height(this.isExpand ? $r('app.float.expanded_item_height') : $r('app.float.list_item_height'))
      .width(CommonConstants.FULL_WIDTH)
      .opacity(this.latestProgress == CommonConstants.SLIDER_MAX_VALUE ? CommonConstants.OPACITY :
      CommonConstants.NO_OPACITY)
      .borderRadius(CommonConstants.LIST_RADIUS)
      .animation({ duration: CommonConstants.DURATION })
      .backgroundColor(this.selectedTasks[this.index] ? $r('app.color.edit_blue') : Color.White)
      .onClick((e) => {
        if (this.mode == CommonConstants.CLICK_SLIDER_MODE) {
          this.mode = CommonConstants.DEFAULT_SLIDER_MODE
          return
        }
        if (!this.isEdit) {
          animateTo({ duration: CommonConstants.DURATION }, () => {
            this.isExpand = !this.isExpand
          })
          this.clickIndex = this.index
        }
      })
      .padding({
        top: $r('app.float.list_padding_top'),
        bottom: $r('app.float.list_padding_bottom'),
        left: $r('app.float.main_padding_left'),
        right: this.isEdit ? $r('app.float.list_edit_padding') : $r('app.float.list_padding')
      })

      // 编辑模式下复选框
      if (this.isEdit) {
        Row() {
          Column() {
            Checkbox()
              .margin({ right: $r('app.float.list_padding') })
              .width(CommonConstants.CHECKBOX_WIDTH)
              .selectedColor($r('app.color.main_blue'))
              .onChange((value) => {
                this.selectedTasks[this.index] = value
              })
              .select(this.selectedTasks[this.index])
          }
          .justifyContent(FlexAlign.Center)
          .height('100%')

        }
         .width(CommonConstants.FULL_WIDTH)
        .justifyContent(FlexAlign.End)
        .height(this.isExpand ? $r('app.float.expanded_item_height') : $r('app.float.list_item_height'))
      }
    }.width(CommonConstants.FULL_WIDTH)
    .height(this.isExpand ? $r('app.float.expanded_item_height') : $r('app.float.list_item_height'))
    .padding(10)

  }
}

@Extend(Text)
function opacityTextStyle() {
  .fontSize($r('app.float.text_font'))
  .fontColor($r('app.color.title_black_color'))
  .opacity(CommonConstants.OPACITY)
  .fontWeight(CommonConstants.FONT_WEIGHT)

}

@Extend(Text)
function subTitleStyle() {
  .fontSize($r('app.float.list_font'))
  .fontWeight(CommonConstants.FONT_WEIGHT)
  .fontColor($r('app.color.title_black_color'))
}