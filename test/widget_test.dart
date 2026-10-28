import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('Home screen displays its title, movies, and booking buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text(appTitle), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('HOW TO TRAIN YOUR DRAGON 2'),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('THE WILD ROBOT'),
      ),
      findsOneWidget,
    );
    expect(find.text('BOOK NOW'), findsNWidgets(2));
    expect(find.byType(ListView), findsWidgets);
  });

  testWidgets(
      'Booking either movie shows its listing, supports returning, and gives booking feedback',
      (WidgetTester tester) async {
    final basket = BasketRepository.instance;
    basket.clear();

    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('BOOK NOW').first);
    await tester.pumpAndSettle();

    expect(find.byType(MovieListing), findsOneWidget);
    expect(find.text('HOW TO TRAIN YOUR DRAGON 2 (PG)'), findsOneWidget);
    expect(find.text('Thursday 22 Oct 2026, 18:00'), findsOneWidget);
    await tester.ensureVisible(find.text('Add to order'));
    await tester.tap(find.text('Add to order'));
    await tester.pumpAndSettle();

    expect(find.text('Select at least one ticket to add.'), findsOneWidget);
    expect(basket.getItems(), isEmpty);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('BOOK NOW'), findsNWidgets(2));

    await tester.tap(find.text('BOOK NOW').last);
    await tester.pumpAndSettle();

    expect(find.byType(MovieListing), findsOneWidget);
    expect(find.text('THE WILD ROBOT (PG)'), findsOneWidget);
    expect(find.text('Thursday 22 Oct 2026, 20:30'), findsOneWidget);

    await tester.ensureVisible(find.byType(DropdownMenu<int>));
    await tester.tap(find.byType(DropdownMenu<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add to order'));
    await tester.tap(find.text('Add to order'));
    await tester.pumpAndSettle();

    expect(
        find.text('2 tickets have been added to your order'), findsOneWidget);
    expect(basket.getItems(), hasLength(1));
    expect(basket.getItems().single.movie.id, 'the_wild_robot');
    expect(basket.getItems().single.quantity, 2);
    expect(basket.getTotalItems(), 2);
    expect(basket.getTotal(), 12.0);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('BOOK NOW'), findsNWidgets(2));

    await tester.tap(find.text('BOOK NOW').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(DropdownMenu<int>));
    await tester.tap(find.byType(DropdownMenu<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add to order'));
    await tester.tap(find.text('Add to order'));
    await tester.pumpAndSettle();
    expect(basket.getItems(), hasLength(2));
    expect(basket.getItems().last.movie.id, 'how_to_train_your_dragon_2');

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Basket'));
    await tester.pumpAndSettle();

    expect(find.textContaining('How to Train Your Dragon 2'), findsOneWidget);
    expect(find.textContaining('The Wild Robot'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove How to Train Your Dragon 2'));
    await tester.pumpAndSettle();

    expect(find.textContaining('How to Train Your Dragon 2'), findsNothing);
    expect(find.textContaining('The Wild Robot'), findsOneWidget);
    expect(basket.getItems(), hasLength(1));
    expect(basket.getItems().single.movie.id, 'the_wild_robot');
    expect(basket.getItems().single.quantity, 2);

    await tester.tap(find.text('BUY TICKETS'));
    await tester.pumpAndSettle();

    expect(find.text('Your tickets have been checked out.'), findsOneWidget);
    expect(find.text('Your basket is empty.'), findsOneWidget);
    expect(basket.getItems(), isEmpty);
    expect(basket.getTotalItems(), 0);
  });

  testWidgets('Drawer navigates to the basket and settings routes',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Basket'));
    await tester.pumpAndSettle();

    expect(find.text(appTitle), findsOneWidget);
    expect(
      ModalRoute.of(tester.element(find.text(appTitle)))?.settings.name,
      '/basket',
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Settings'));
    await tester.pumpAndSettle();

    expect(find.text('My Settings'), findsOneWidget);
    expect(
      ModalRoute.of(tester.element(find.text('My Settings')))?.settings.name,
      '/settings',
    );
  });

  testWidgets('Basket displays items, totals, and supports remove and clear',
      (WidgetTester tester) async {
    final basket = BasketRepository.instance;
    basket.clear();
    final movies = await MovieRepository().getMovies();
    basket.addItem(BasketItem(movie: movies[0], quantity: 2));
    basket.addItem(BasketItem(movie: movies[1], quantity: 1));

    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Basket'));
    await tester.pumpAndSettle();

    expect(find.textContaining(movies[0].title), findsOneWidget);
    expect(find.textContaining(movies[1].title), findsOneWidget);
    expect(find.text('MY ORDER'), findsOneWidget);
    expect(find.text('Item'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
    expect(find.textContaining('2 Standard'), findsOneWidget);
    expect(find.textContaining('1 Standard'), findsOneWidget);
    expect(find.text('Service Charge'), findsOneWidget);
    expect(find.text('£4.00'), findsOneWidget);
    expect(find.text('Total Due'), findsOneWidget);
    expect(find.text('£22.00'), findsOneWidget);
    expect(find.text('UPDATE ORDER'), findsOneWidget);
    expect(find.text('BUY TICKETS'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove ${movies[0].title}'));
    await tester.pumpAndSettle();

    expect(find.textContaining(movies[0].title), findsNothing);
    expect(find.textContaining(movies[1].title), findsOneWidget);
    expect(find.text('£10.00'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove ${movies[1].title}'));
    await tester.pumpAndSettle();

    expect(find.text('Your basket is empty.'), findsOneWidget);
    expect(basket.getItems(), isEmpty);
  });
}
