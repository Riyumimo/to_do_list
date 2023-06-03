class Note {
  int? id;
  String? title;
  String? note;
  String? dateTime;
  int? isComplete;
  String? startTime;
  String? endTime;
  int? remind;
  String? repeat;
  int? colors;

  Note({
    this.id,
    required this.colors,
    required this.title,
    required this.isComplete,
    required this.note,
    required this.dateTime,
    required this.startTime,
    required this.endTime,
    required this.remind,
    required this.repeat,
  });

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    dateTime = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    remind = json['remind'];
    repeat = json['repeat'];
    colors = json['colors'];
    isComplete = json['isComplete'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['note'] = this.note;
    data['date'] = this.dateTime;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['remind'] = this.remind;
    data['repeat'] = this.repeat;
    data['colors'] = this.colors;
    data['isComplete'] = this.isComplete;
    return data;
  }
}
