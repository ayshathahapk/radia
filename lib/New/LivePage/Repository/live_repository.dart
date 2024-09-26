import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radia/Models/get_server_details.dart';
import 'package:radia/Models/liverate_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../Core/Utils/firebase_constants.dart';
import '../../../Models/get_commodity_model.dart';

// class LiveRateNotifier extends StateNotifier<LiveRateModel?> {
//   IO.Socket? _socket;
//   Map<String, dynamic> marketData = {};
//   LiveRateNotifier() : super(null) {
//     _initializeSocketConnection();
//   }
//   final link = 'https://capital-server-9ebj.onrender.com';
//   void _initializeSocketConnection() {
//     _socket = IO.io(link, <String, dynamic>{
//       'transports': ['websocket'],
//       'query': {
//         'secret': 'aurify@123', // Secret key for authentication
//       },
//     });
//     final commodityArray = ['GOLD', 'SILVER'];
//     _socket?.on('connect', (_) {
//       print('Connected to WebSocket server');
//       _requestMarketData(commodityArray);
//     });
//
//     _socket?.on('market-data', (data) {
//       // print("********************************************");
//       // print(data.toString());
//       if (data != null && data['symbol'] != null) {
//         marketData[data['symbol']] = data;
//         state = LiveRateModel.fromJson(marketData);
//         // print("###############################################");
//         // print(marketData);
//       }
//     });
//
//     _socket?.on('connect_error', (data) {
//       print('Connection Error: $data');
//     });
//
//     _socket?.on('disconnect', (_) {
//       print('Disconnected from WebSocket server');
//     });
//   }
//
//   void _requestMarketData(List<String> symbols) {
//     _socket?.emit('request-data', symbols);
//   }
//
//   @override
//   void dispose() {
//     _socket?.disconnect();
//     super.dispose();
//   }
// }
//
// final liveRateProvider =
//     StateNotifierProvider<LiveRateNotifier, LiveRateModel?>((ref) {
//   return LiveRateNotifier();
// });

/// gdgsdsdfsfsfsdfsfsdfs
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:radia/Models/liverate_model.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;
//
// class LiveRateNotifier extends StateNotifier<LiveRateModel?> {
//   WebSocketChannel? _channel;
//   Map<String, dynamic> marketData = {};
//   Timer? _reconnectTimer;
//   int _reconnectAttempts = 0;
//   final int _maxReconnectAttempts = 5;
//   final Duration _reconnectInterval = Duration(seconds: 5);
//
//   LiveRateNotifier() : super(null) {
//     _initializeWebSocketConnection();
//   }
//
//   final link = 'wss://capital-server-9ebj.onrender.com';
//
//   void _initializeWebSocketConnection() {
//     try {
//       _channel = WebSocketChannel.connect(
//         Uri.parse('$link?secret=aurify@123'),
//       );
//
//       _channel?.stream.listen(
//         _handleMessage,
//         onDone: _handleDisconnection,
//         onError: _handleError,
//       );
//
//       final commodityArray = ['GOLD', 'SILVER'];
//       _requestMarketData(commodityArray);
//     } catch (e) {
//       print('Error initializing WebSocket: $e');
//       _scheduleReconnect();
//     }
//   }
//
//   void _handleMessage(dynamic message) {
//     try {
//       final data = jsonDecode(message);
//       if (data != null && data['symbol'] != null) {
//         marketData[data['symbol']] = data;
//         state = LiveRateModel.fromJson(marketData);
//       }
//     } catch (e) {
//       print('Error handling message: $e');
//     }
//   }
//
//   void _handleDisconnection() {
//     print('WebSocket connection closed');
//     _scheduleReconnect();
//   }
//
//   void _handleError(error) {
//     print('WebSocket error: $error');
//     _scheduleReconnect();
//   }
//
//   void _scheduleReconnect() {
//     if (_reconnectAttempts < _maxReconnectAttempts) {
//       _reconnectTimer?.cancel();
//       _reconnectTimer = Timer(_reconnectInterval, () {
//         print('Attempting to reconnect...');
//         _reconnectAttempts++;
//         _initializeWebSocketConnection();
//       });
//     } else {
//       print('Max reconnection attempts reached');
//     }
//   }
//
//   void _requestMarketData(List<String> symbols) {
//     try {
//       _channel?.sink
//           .add(jsonEncode({'type': 'request-data', 'symbols': symbols}));
//     } catch (e) {
//       print('Error requesting market data: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     _reconnectTimer?.cancel();
//     _channel?.sink.close(status.goingAway);
//     super.dispose();
//   }
// }
//
// final liveRateProvider =
//     StateNotifierProvider<LiveRateNotifier, LiveRateModel?>((ref) {
//   return LiveRateNotifier();
// });
///
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:radia/Models/liverate_model.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/io.dart';
//
// class LiveRateNotifier extends StateNotifier<LiveRateModel?> {
//   WebSocketChannel? _channel;
//   Map<String, dynamic> marketData = {};
//   Timer? _reconnectTimer;
//   int _reconnectAttempts = 0;
//   final int _maxReconnectAttempts = 5;
//   final Duration _reconnectInterval = Duration(seconds: 5);
//
//   LiveRateNotifier() : super(null) {
//     _initializeWebSocketConnection();
//   }
//
//   final String link = 'wss://capital-server-9ebj.onrender.com';
//
//   void _initializeWebSocketConnection() {
//     try {
//       print('Attempting to connect to WebSocket...');
//       _channel = IOWebSocketChannel.connect(
//         Uri.parse('$link?secret=aurify@123'),
//         pingInterval: Duration(seconds: 30),
//         headers: {
//           'User-Agent': 'YourAppName/1.0',
//           'Origin': 'https://yourdomain.com',
//         },
//       );
//
//       print('WebSocket channel created. Listening for messages...');
//
//       _channel?.stream.listen(
//         _handleMessage,
//         onDone: _handleDisconnection,
//         onError: _handleError,
//         cancelOnError: false,
//       );
//
//       final commodityArray = ['GOLD', 'SILVER'];
//       _requestMarketData(commodityArray);
//     } catch (e) {
//       print('Error initializing WebSocket: $e');
//       _scheduleReconnect();
//     }
//   }
//
//   void _handleMessage(dynamic message) {
//     try {
//       print('Received message: $message');
//       final data = jsonDecode(message);
//       if (data != null && data['symbol'] != null) {
//         marketData[data['symbol']] = data;
//         state = LiveRateModel.fromJson(marketData);
//       }
//     } catch (e) {
//       print('Error handling message: $e');
//     }
//   }
//
//   void _handleDisconnection() {
//     print('WebSocket connection closed');
//     _scheduleReconnect();
//   }
//
//   void _handleError(error) {
//     print('WebSocket error: $error');
//     _scheduleReconnect();
//   }
//
//   void _scheduleReconnect() {
//     if (_reconnectAttempts < _maxReconnectAttempts) {
//       _reconnectTimer?.cancel();
//       _reconnectTimer = Timer(_reconnectInterval, () {
//         print(
//             'Attempting to reconnect... (Attempt ${_reconnectAttempts + 1}/$_maxReconnectAttempts)');
//         _reconnectAttempts++;
//         _initializeWebSocketConnection();
//       });
//     } else {
//       print('Max reconnection attempts reached');
//     }
//   }
//
//   void _requestMarketData(List<String> symbols) {
//     try {
//       final request = jsonEncode({'type': 'request-data', 'symbols': symbols});
//       print('Sending request: $request');
//       _channel?.sink.add(request);
//     } catch (e) {
//       print('Error requesting market data: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     print('Disposing LiveRateNotifier');
//     _reconnectTimer?.cancel();
//     _channel?.sink.close();
//     super.dispose();
//   }
// }
//
// final liveRateProvider =
//     StateNotifierProvider<LiveRateNotifier, LiveRateModel?>((ref) {
//   return LiveRateNotifier();
// });
///
class LiveRateNotifier extends StateNotifier<LiveRateModel?> {
  IO.Socket? _socket;
  Map<String, dynamic> marketData = {};
  bool _isConnected = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  final Duration _reconnectInterval = const Duration(seconds: 1);

  LiveRateNotifier() : super(null) {
    fetchServerLink().then(
      (value) {
        initializeSocketConnection(link: value);
      },
    );
  }

  // final link = 'https://capital-server-9ebj.onrender.com';
  // final commodityArray = ['GOLD', 'SILVER'];

  Future<List<String>> fetchCommodityArray() async {
    const id = "IfiuH/ko+rh/gekRvY4Va0s+aGYuGJEAOkbJbChhcqo=";
    final response = await http.get(
      Uri.parse(
          '${FirebaseConstants.baseUrl}get-commodities/${FirebaseConstants.adminId}'),
      headers: {
        'X-Secret-Key': id,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      // List<dynamic> data = json.decode(response.body);
      final commudity = GetCommodityModel.fromMap(json.decode(response.body));
      // return data.map((item) => item.toString()).toList();

      return commudity.commodities;
    } else {
      throw Exception('Failed to load commodity data');
    }
  }

  Future<String> fetchServerLink() async {
    final response = await http.get(
      Uri.parse('${FirebaseConstants.baseUrl}get-server'),
      headers: {
        'X-Secret-Key': FirebaseConstants.secretKey,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      // List<dynamic> data = json.decode(response.body);
      final commudity = GetServerModel.fromMap(json.decode(response.body));
      // return data.map((item) => item.toString()).toList();
      return commudity.info.serverUrl;
    } else {
      throw Exception('Failed to load commodity data');
    }
  }

  Future<void> initializeSocketConnection({required String link}) async {
    _socket = IO.io(link, <String, dynamic>{
      'transports': ['websocket'],
      'query': {
        'secret': 'aurify@123', // Secret key for authentication
      },
      'reconnection': false, // We'll handle reconnection manually
    });

    _socket?.onConnect((_) async {
      print('Connected to WebSocket server');
      _isConnected = true;
      _reconnectAttempts = 0;
      List<String> commodityArray = await fetchCommodityArray();
      _requestMarketData(commodityArray);
    });

    _socket?.on('market-data', (data) {
      if (data != null && data['symbol'] != null) {
        marketData[data['symbol']] = data;
        state = LiveRateModel.fromJson(marketData);
        print("Market data updated: ${data['symbol']}");
      }
    });

    _socket?.onConnectError((data) {
      print('Connection Error: $data');
      _handleDisconnection();
    });

    _socket?.onDisconnect((_) {
      print('Disconnected from WebSocket server');
      _handleDisconnection();
    });

    _socket?.connect();
  }

  void _handleDisconnection() {
    _isConnected = false;
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _scheduleReconnect();
    } else {
      print('Max reconnection attempts reached');
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectInterval, () {
      if (!_isConnected) {
        _reconnectAttempts++;
        print(
            'Attempting to reconnect... (Attempt $_reconnectAttempts/$_maxReconnectAttempts)');
        _socket?.connect();
      }
    });
  }

  void _requestMarketData(List<String> symbols) {
    if (_isConnected) {
      _socket?.emit('request-data', [symbols]);
    }
  }

  Future<void> refreshData() async {
    if (_isConnected) {
      List<String> commodityArray = await fetchCommodityArray();
      _requestMarketData(commodityArray);
    } else {
      print('Not connected. Attempting to reconnect...');
      _socket?.connect();
    }
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    _socket?.disconnect();
    _socket?.dispose();
    super.dispose();
  }
}

final liveRateProvider =
    StateNotifierProvider<LiveRateNotifier, LiveRateModel?>((ref) {
  return LiveRateNotifier();
});
