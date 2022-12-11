import 'package:json_annotation/json_annotation.dart';
import 'package:techoffice/models/User.dart';

part 'Order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  int id;
  int number;
  String project;
  String start_date;
  String finish_date;
  String order_date;
  String dxf_file;
  String pdf_file;
  String unit;
  String material;
  String finishing;
  double count;
  double done_count;
  double shipped_count;
  String notes;
  String problems;
  String status;
  int archived;

  User user;

  Order(
      {this.id,
      this.number,
      this.unit,
      this.pdf_file,
      this.dxf_file,
      this.project,
      this.start_date,
      this.finish_date,
      this.order_date,
      this.material,
      this.finishing,
      this.count,
      this.done_count,
      this.shipped_count,
      this.notes,
      this.problems,
      this.status = 'started',
      this.archived = 0,
      this.user});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  String toString() {
    return "امر تصنيع رقم : ${this.number}" +
        "\n" +
        "مشروع : " +
        this.project +
        "\n" +
        "الخامة : ${this.material ?? "--"}" +
        "(${this.finishing ?? "--"})" +
        "\n" +
        "الكمية المطلوبة : ${this.count ?? "--"} ${this.unit ?? ""}" +
        "\n" +
        "كمية ماتم انتاجة : ${this.done_count ?? "--"}  ${this.unit ?? ""}" +
        "\n" +
        "كمية ما تم تحميلة : ${this.shipped_count ?? "--"}  ${this.unit ?? ""}" +
        "\n" +
        "-----------" +
        "\n" +
        "*ملاحظات*" +
        "\n" +
        "${this.notes ?? "--"}" +
        "\n" +
        "-----------" +
        "\n" +
        "*المشاكل*" +
        "\n" +
        "${this.problems ?? "--"}";
  }
}
