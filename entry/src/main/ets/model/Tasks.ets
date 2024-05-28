import Task from './Task'

// 任务操作类
class Tasks{
  private _allData:Task[] = []

  public get allData(): Task[]{
    return this._allData
  }

  //添加任务
  add(task: Task){
    console.log('添加任务:' , task.name)
    this._allData.push(task)
  }
  // 删除任务，selected ：任务选中状态数组，长度与任务列表一致，
  del(selected: boolean[]){
    console.log('刪除:', selected)
    // 仅保留 对应索引为false的数据
    this._allData = this._allData.filter((_, index) => !selected[index])
   /* // 遍历
    for (let i = 0; i < selected.length; i++) {
     if(selected[i]){ // 如果被选中
       this._allData.splice(i,1) // 从数组中删除
     }
    }*/
  }
  //获取最新一条任务的进度
  getLastedProgress(){
    if(this._allData.length == 0){
      return 0
    }
    return this._allData[this._allData.length - 1].progress
  }

  //更新指定一个任务的进度
  updateTask(index:number, progress: number, update: string){
    if(this._allData[index]){
      this._allData[index].progress = progress
      this._allData[index].update = update
      return true
    }
    return false
  }
}

export default new Tasks()