// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addCart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddCartModelAdapter extends TypeAdapter<AddCartModel> {
  @override
  final int typeId = 1;

  @override
  AddCartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddCartModel(
      id: fields[0] as int,
      img: fields[1] as String,
      title: fields[2] as String,
      avgRating: fields[3] as String,
      price: fields[4] as String,
      quantityUnit: fields[5] as String,
      quantity: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AddCartModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.img)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.avgRating)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.quantityUnit)
      ..writeByte(6)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddCartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
