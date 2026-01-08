import '../../domains/services/rooms_servive.dart';
import 'room_local_data_source.dart';

class RoomDataManager {
  final RoomLocalDataSource localDataSource;

  RoomDataManager({required this.localDataSource});

  Future<RoomService> loadRoomService() async {
    final loaded = await localDataSource.load();
    return RoomService(localDataSource: localDataSource)
      ..rooms = loaded.rooms
      ..tenants = loaded.tenants
      ..payments = loaded.payments;
  }

  Future<void> saveRoomService(RoomService service) async {
    await localDataSource.save(
      rooms: service.rooms,
      tenants: service.tenants,
      payments: service.payments,
    );
  }
}
