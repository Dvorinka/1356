part of 'cached_goal_model.dart';

class CachedGoalAdapter extends TypeAdapter<CachedGoal> {
  @override
  final int typeId = 0;

  @override
  CachedGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedGoal(
      id: fields[0] as String,
      ownerId: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String?,
      progress: fields[4] as int,
      locationLat: fields[5] as double?,
      locationLng: fields[6] as double?,
      locationName: fields[7] as String?,
      imageUrl: fields[8] as String?,
      completed: fields[9] as bool,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
      isDirty: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CachedGoal obj) {
    writer.writeByte(13);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.ownerId);
    writer.writeByte(2);
    writer.write(obj.title);
    writer.writeByte(3);
    writer.write(obj.description);
    writer.writeByte(4);
    writer.write(obj.progress);
    writer.writeByte(5);
    writer.write(obj.locationLat);
    writer.writeByte(6);
    writer.write(obj.locationLng);
    writer.writeByte(7);
    writer.write(obj.locationName);
    writer.writeByte(8);
    writer.write(obj.imageUrl);
    writer.writeByte(9);
    writer.write(obj.completed);
    writer.writeByte(10);
    writer.write(obj.createdAt);
    writer.writeByte(11);
    writer.write(obj.updatedAt);
    writer.writeByte(12);
    writer.write(obj.isDirty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedGoalAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
