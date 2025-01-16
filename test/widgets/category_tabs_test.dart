import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/category_tab.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_state.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_event.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';

class MockCategoryBloc extends Mock implements CategoryBloc {}

void main() {
  group('CategoryTabs Integration Test', () {
    late CategoryBloc categoryBloc;

    setUp(() {
      categoryBloc = MockCategoryBloc();
    });

    tearDown(() {
      categoryBloc.close();
    });

    testWidgets('shows loading state initially', (WidgetTester tester) async {
      // Arrange
      when(() => categoryBloc.state).thenReturn(CategoryLoading());

      // Act
      await tester.pumpWidget(
        BlocProvider<CategoryBloc>.value(
          value: categoryBloc,
          child: const MaterialApp(home: CategoryTabs()),
        ),
      );

      // Assert
      expect(find.text('Loading...'), findsNWidgets(3));
    });

    testWidgets('shows error state with retry button',
        (WidgetTester tester) async {
      // Arrange
      when(() => categoryBloc.state)
          .thenReturn(CategoryFailed('Error loading categories'));
      when(() => categoryBloc.add(any())).thenReturn(null);

      // Act
      await tester.pumpWidget(
        BlocProvider<CategoryBloc>.value(
          value: categoryBloc,
          child: const MaterialApp(home: CategoryTabs()),
        ),
      );

      // Assert
      expect(find.text('Error loading categories'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      // Retry logic
      await tester.tap(find.text('Retry'));
      verify(() => categoryBloc.add(any(that: isA<LoadCategories>())))
          .called(1);
    });

    testWidgets('displays loaded categories and handles taps',
        (WidgetTester tester) async {
      // Arrange
      final mockCategories = [
        Category(id: '1', name: 'Category 1', imageUrl: ''),
        Category(id: '2', name: 'Category 2', imageUrl: ''),
      ];
      when(() => categoryBloc.state).thenReturn(CategoryLoaded(
        categories: mockCategories,
        hasReachedMax: true,
        page: 1,
      ));

      // Act
      await tester.pumpWidget(
        BlocProvider<CategoryBloc>.value(
          value: categoryBloc,
          child: const MaterialApp(home: CategoryTabs()),
        ),
      );

      // Assert
      expect(find.text('Todo'), findsOneWidget);
      expect(find.text('Category 1'), findsOneWidget);
      expect(find.text('Category 2'), findsOneWidget);

      // Tap on a category
      await tester.tap(find.text('Category 1'));
      await tester.pump();

      // The selected category should change color (assert UI updates)
      final selectedCategory = tester.widget<Container>(
        find.widgetWithText(Container, 'Category 1'),
      );
      expect((selectedCategory.decoration as BoxDecoration).color,
          const Color(0xFF2000B1));
    });
  });
}
