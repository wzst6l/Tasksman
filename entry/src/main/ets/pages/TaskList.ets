import { TaskItem } from './TaskItem'
import Tasks from '../model/Tasks';
import Task from '../model/Task';
import { CommonConstants } from '../common/constant/CommonConstant';
import currentTime from '../common/utils/DateLocal';


//@Entry
@Component
export struct TaskList {
  @State isEdit: boolean = false // 是否编辑状态
  @Link tasks: Task[] // = [new Task('1', currentTime(), 10), new Task('2', currentTime(), 30), new Task('3', currentTime(), 70)]
  @State @Watch('onSelectedTasksChange') selectedTasks: boolean[] = [] // 选中的任务组
  @State clickIndex: number = CommonConstants.DEFAULT_CLICK_INDEX // 点击的任务索引
  @State selectAll: boolean = false // 全选
  // 预览用State, 实际：Consume，因为子组件可以变更它
  @Consume totalProgressChanged: boolean  // = false // 总进度是否发生变化
  onAddClick?: () => void // 点击新增任务的回调函数

  // 判断是否有被选中的任务
  isAnyTaskSelected() {
    return this.selectedTasks.some(val => val == true)
  }

  onSelectedTasksChange(){
    this.selectAll = this.tasks.length == this.selectedTasks.length && this.selectedTasks.every(item => !!item)

  }

  // 删除选中任务，并重置各状态
  delSelected() {
    Tasks.del(this.selectedTasks)
    this.tasks = Tasks.allData
    this.isEdit = false // 删除后退出编辑模式
    this.selectAll = false
    this.selectedTasks = this.tasks.map(() => false)
    // 删除任务，需要重新计算总进度
    this.totalProgressChanged = !this.totalProgressChanged

  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.sub_goals'))
          .fontSize($r('app.float.secondary_title'))
          .fontWeight(CommonConstants.FONT_WEIGHT_LARGE)
        Blank()
        if (this.tasks.length > 0) {
          if (this.isEdit) {
            // 取消
            Text($r('app.string.cancel_button')).onClick(e => {
              // 状态全置为false
              this.isEdit = false
              this.selectAll = false
              // 将任务列表映射为false 的数组
              this.selectedTasks = this.tasks.map(() => false)
            }).operateTextStyle($r('app.color.main_blue'))
              .margin({ left: $r('app.float.operate_button_margin') })

            Text($r('app.string.select_all_button'))
              .operateTextStyle($r('app.color.main_blue'))
              .margin({ left: $r('app.float.operate_button_margin') })

            Checkbox()
              .select(this.selectAll)
              .selectedColor($r('app.color.main_blue'))
              .width(CommonConstants.CHECKBOX_WIDTH)
              .onClick(e => {
                this.selectAll = !this.selectAll
                // 将任务列表映射为与 this.selectAll 状态相同的数组
                this.selectedTasks = this.tasks.map(() => this.selectAll)
              })


          } else {
            //编辑
            Text($r('app.string.edit_button'))
              .onClick(e => {
                this.isEdit = true
              })
              .operateTextStyle($r('app.color.main_blue'))
          }

        }
      }
      .width(CommonConstants.FULL_WIDTH)
      .height($r('app.float.history_line_height'))
      .padding({
        right: $r('app.float.list_padding_right'),
        left: $r('app.float.list_padding')
      })

      Column() {
        if (this.tasks.length == 0) {
          Text('—当前还没有任务哦—')
            .margin({
              top: $r('app.float.list_margin_top')
            })
            .opacityTextStyle()
        }
        // 遍历显示任务
        List({ space: CommonConstants.LIST_SPACE }) {
          ForEach(this.tasks, (item: Task, index) => {
            ListItem() {
              TaskItem({
                task: item,
                selectedTasks: this.selectedTasks,
                clickIndex: $clickIndex,
                isEdit: this.isEdit,
                index: index
              })
            }

          })
        }.width(CommonConstants.FULL_WIDTH)
        .height(CommonConstants.LIST_HEIGHT) // 80%
        .edgeEffect(EdgeEffect.Spring) //边缘动效：回弹
        .margin({
          top: $r('app.float.list_margin_top')
        })

        Blank()

        if (this.isEdit) {
          Button($r('app.string.delete_button'))
            .opacity(this.isAnyTaskSelected() ? CommonConstants.NO_OPACITY : CommonConstants.OPACITY)
            .enabled(this.isAnyTaskSelected() ? true : false)
            .operateButtonStyle($r('app.color.main_red'))
            .onClick(e => {
              this.delSelected()
            })
        } else {
          // 新增
          Button($r('app.string.add_task'))
            .operateButtonStyle($r('app.color.main_blue'))
            .onClick(e => {
              if (this.onAddClick) {
                this.onAddClick()
              }
            })
        }

      }
      .height('100%').width('100%')
    }
    .height(CommonConstants.FULL_HEIGHT)
    .width(CommonConstants.FULL_WIDTH)
    .padding({
      top: $r('app.float.operate_row_margin')
    })
  }
}


// 可点击的文字样式
@Extend(Text)
function operateTextStyle(color: Resource) {
  .fontSize($r('app.float.text_button_font'))
  .fontColor(color)
  .lineHeight($r('app.float.text_line_height'))
  .fontWeight(CommonConstants.FONT_WEIGHT)

}

// 页面底部的按钮（删除/新增）
@Extend(Button)
function operateButtonStyle(color: Resource) {
  .fontSize($r('app.float.button_font'))
  .fontColor(color)
  .fontWeight(CommonConstants.FONT_WEIGHT)
  .width($r('app.float.button_width'))
  .height($r('app.float.button_height'))
  .backgroundColor($r('app.color.button_background'))
}

@Extend(Text)
function opacityTextStyle() {
  .fontSize($r('app.float.text_font'))
  .fontColor($r('app.color.title_black_color'))
  .opacity(CommonConstants.OPACITY)
  .fontWeight(CommonConstants.FONT_WEIGHT)

}