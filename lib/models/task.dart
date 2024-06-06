class Task{
  String? tskId;
  String? userID;
  String? task;
  String? timeStamp;


  Task(this.tskId, this.userID, this.task, this.timeStamp);

  Map<String, dynamic> toJson(){
    return{
      "tskId":tskId,
      'userID':userID,
      'task':task,
      'timeStamp':timeStamp
    };
  }

  Task.fromJson(Map<String, dynamic>map){
    tskId = map['tskId'];
    userID = map['userID'];
    task = map['task'];
    timeStamp = map['timeStamp'];
  }
}