class Tools {
  String GetUniqueId() =>
      DateTime.now().year.toString().substring(3, 2) +
      DateTime.now().month.toString() +
      DateTime.now().day.toString() +
      DateTime.now().hour.toString() +
      DateTime.now().minute.toString() +
      DateTime.now().second.toString();
}
