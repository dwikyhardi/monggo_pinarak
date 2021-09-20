import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'dio_client.g.dart';

@RestApi(baseUrl: '')
abstract class DioClient {
  factory DioClient(Dio dio, {String baseUrl}) = _DioClient;

  @GET('{order_id}/status')
  Future<Map<String, dynamic>> getOrderStatus(@Path('order_id') String orderId);

  @POST('charge')
  Future<Map<String, dynamic>> chargeOrder(@Body() Map<String, dynamic> data);

  @POST('{order_id}/cancel')
  Future<Map<String, dynamic>> cancelOrder(
      @Body() Map<String, dynamic> data, @Path('order_id') String orderId);
}
