import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';

const testMovie1 = Movie(
  id: 'test_movie_1',
  title: 'Test Movie 1',
  ageRating: 'PG',
  synopsis: 'A test movie.',
  screeningTime: 'Friday 23 Oct 2026, 18:00',
  imagePath: 'assets/images/httyd2.jpg',
  price: 10.0,
);

const testMovie2 = Movie(
  id: 'test_movie_2',
  title: 'Test Movie 2',
  ageRating: '12A',
  synopsis: 'Another test movie.',
  screeningTime: 'Friday 23 Oct 2026, 20:00',
  imagePath: 'assets/images/wild_robot.jpg',
  price: 6.0,
);

void main() {
  final basket = BasketRepository.instance;

  setUp(basket.clear);

  group('BasketRepository tests', () {
    test('starts empty with zero tickets and total', () {
      expect(basket.getItems(), isEmpty);
      expect(basket.getTotalItems(), 0);
      expect(basket.totalItemCount, 0);
      expect(basket.getTotal(), 0.0);
      expect(basket.getServiceCharge(), 0.0);
      expect(basket.getTotalDue(), 0.0);
    });

    test('adds tickets and calculates ticket count and total', () {
      basket.addItem(const BasketItem(movie: testMovie1, quantity: 2));
      basket.addItem(const BasketItem(movie: testMovie2, quantity: 1));

      expect(basket.getItems(), hasLength(2));
      expect(basket.getItems()[0].movie, testMovie1);
      expect(basket.getItems()[1].movie, testMovie2);
      expect(basket.getTotalItems(), 3);
      expect(basket.totalItemCount, 3);
      expect(basket.getTotal(), 26.0);
      expect(basket.getServiceCharge(), 4.0);
      expect(basket.getTotalDue(), 30.0);
    });

    test('removes a basket item and updates the total', () {
      basket.addItem(const BasketItem(movie: testMovie1, quantity: 1));
      basket.addItem(const BasketItem(movie: testMovie2, quantity: 2));

      basket.removeItem(0);

      expect(basket.getItems(), hasLength(1));
      expect(basket.getItems().single.movie, testMovie2);
      expect(basket.getTotalItems(), 2);
      expect(basket.getTotal(), 12.0);
      expect(basket.getServiceCharge(), 4.0);
      expect(basket.getTotalDue(), 16.0);
    });

    test('ignores invalid removal indexes', () {
      basket.addItem(const BasketItem(movie: testMovie1, quantity: 1));

      basket.removeItem(-1);
      basket.removeItem(1);

      expect(basket.getItems(), hasLength(1));
      expect(basket.getTotal(), 10.0);
      expect(basket.getTotalDue(), 14.0);
    });

    test('clears all basket items and resets totals', () {
      basket.addItem(const BasketItem(movie: testMovie1, quantity: 2));
      basket.addItem(const BasketItem(movie: testMovie2, quantity: 1));

      basket.clear();

      expect(basket.getItems(), isEmpty);
      expect(basket.getTotalItems(), 0);
      expect(basket.getTotal(), 0.0);
      expect(basket.getServiceCharge(), 0.0);
      expect(basket.getTotalDue(), 0.0);
    });

    test('returns an unmodifiable list of basket items', () {
      basket.addItem(const BasketItem(movie: testMovie1, quantity: 1));

      expect(
        () => basket.getItems().clear(),
        throwsUnsupportedError,
      );
    });
  });
}
