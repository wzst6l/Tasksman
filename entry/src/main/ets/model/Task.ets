export default class Task{
  name:string
  update:string
  progress:number
  typeIndex?: number
  constructor(name: string, update: string, progress: number, typeIndex?: number) {
    this.name = name
    this.update = update
    this.progress = progress
    this.typeIndex = typeIndex
  }
}