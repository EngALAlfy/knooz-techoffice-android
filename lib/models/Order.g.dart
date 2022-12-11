// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    id: json['id'] as int,
    number: json['number'] as int,
    project: json['project'] as String,
    unit: json['unit'] as String,
    start_date: json['start_date'] as String,
    finish_date: json['finish_date'] as String,
    order_date: json['order_date'] as String,
    material: json['material'] as String,
    finishing: json['finishing'] as String,
    count: json['count'] is int
        ? json['count'].toDouble()
        : json['count'] as double,
    done_count: json['done_count'] is int
        ? json['done_count'].toDouble()
        : json['done_count'] as double,
    archived: json['archived'] as int,
    shipped_count: json['shipped_count'] is int
        ? json['shipped_count'].toDouble()
        : json['shipped_count'] as double,
    notes: json['notes'] as String,
    problems: json['problems'] as String,
    pdf_file: json['pdf_file'] as String,
    dxf_file: json['dxf_file'] as String,
    status: json['status'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'unit': instance.unit,
      'pdf_file': instance.pdf_file,
      'dxf_file': instance.dxf_file,
      'project': instance.project,
      'start_date': instance.start_date,
      'finish_date': instance.finish_date,
      'order_date': instance.order_date,
      'material': instance.material,
      'finishing': instance.finishing,
      'count': instance.count,
      'done_count': instance.done_count,
      'shipped_count': instance.shipped_count,
      'notes': instance.notes,
      'problems': instance.problems,
      'status': instance.status,
      'archived': instance.archived,
      //'user': instance.user?.toJson(),
    };
