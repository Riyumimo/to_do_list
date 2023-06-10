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
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['date'] = dateTime;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['remind'] = remind;
    data['repeat'] = repeat;
    data['colors'] = colors;
    data['isComplete'] = isComplete;
    return data;
  }
}
