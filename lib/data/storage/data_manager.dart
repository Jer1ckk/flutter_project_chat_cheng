import '../../domains/services/rooms_servive.dart';
import 'room_local_data_source.dart';

class RoomDataManager {
  final RoomLocalDataSource dataSource;

  RoomDataManager({required this.dataSource});

  Future<RoomService> loadService() async {
    final data = await dataSource.load();
    return RoomService(
      rooms: data.rooms,
      tenants: data.tenants,
      payments: data.payments,
    );
  }

  Future<void> save(RoomService service) async {
    await dataSource.save(
      rooms: service.rooms,
      tenants: service.tenants,
      payments: service.payments,
    );
  }
}
