import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.json(
    body: {
      'message': 'Payment endpoints available',
      'endpoints': [
        'POST /payment/initiate - Initiate payment',
        'POST /payment/verify - Verify payment',
        'GET /payment/status - Check payment status',
      ],
    },
  );
}