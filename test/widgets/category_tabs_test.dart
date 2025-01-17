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
      when(() => categoryBloc.state).thenReturn(CategoryLoading());

      await tester.pumpWidget(
        BlocProvider<CategoryBloc>.value(
          value: categoryBloc,
          child: const MaterialApp(home: CategoryTabs()),
        ),
      );

      expect(find.text('Loading...'), findsNWidgets(3));
    });

    testWidgets('shows error state with retry button',
        (WidgetTester tester) async {
      when(() => categoryBloc.state)
          .thenReturn(CategoryFailed('Error loading categories'));
      when(() => categoryBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(
        BlocProvider<CategoryBloc>.value(
          value: categoryBloc,
          child: const MaterialApp(home: CategoryTabs()),
        ),
      );

      expect(find.text('Error loading categories'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      verify(() => categoryBloc.add(any(that: isA<LoadCategories>())))
          .called(1);
    });

    testWidgets('displays loaded categories and handles taps',
        (WidgetTester tester) async {
      final mockCategories = [
        Category(id: '1', name: 'Category 1', imageUrl: ''),
        Category(id: '2', name: 'Category 2', imageUrl: ''),
      ];
      when(() => categoryBloc.state).thenReturn(CategoryLoaded(
        categories: mockCategories,
        hasReachedMax: true,
        page: 1,
      ));

      await tester.pumpWidget(
        BlocProvider<CategoryBloc>.value(
          value: categoryBloc,
          child: const MaterialApp(home: CategoryTabs()),
        ),
      );

      expect(find.text('Todo'), findsOneWidget);
      expect(find.text('Category 1'), findsOneWidget);
      expect(find.text('Category 2'), findsOneWidget);

      await tester.tap(find.text('Category 1'));
      await tester.pump();

      final selectedCategory = tester.widget<Container>(
        find.widgetWithText(Container, 'Category 1'),
      );
      expect((selectedCategory.decoration as BoxDecoration).color,
          const Color(0xFF2000B1));
    });
  });
}
