import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trivia_clean_arch_tdd/core/network/network_service.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late NetworkService networkService;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkService = NetworkService(
        internetConnectionChecker: mockInternetConnectionChecker);
  });

  test('should return true if internet connection is successful', () async {
    // arrange
    when(() => mockInternetConnectionChecker.connectionStatus)
        .thenAnswer((invocation) async => InternetConnectionStatus.connected);

    // act
    final result = await networkService.isConnected;

    // assert
    verify(() => mockInternetConnectionChecker.connectionStatus);
    expect(result, true);
  });

  test('should return false if internet connection is unsuccessful', () async {
    // arrange
    when(() => mockInternetConnectionChecker.connectionStatus).thenAnswer(
        (invocation) async => InternetConnectionStatus.disconnected);

    // act
    final result = await networkService.isConnected;

    // assert
    verify(() => mockInternetConnectionChecker.connectionStatus);
    expect(result, false);
  });
}
