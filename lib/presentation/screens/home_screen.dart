import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:searchfield/searchfield.dart';

import 'package:telecell_price_history_checker/presentation/screens/data_screen.dart';

import '../../domain/bloc/cubit/sales_data_cubit.dart';
import '../../domain/bloc/debtor_list/debtor_list_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String debtor;

  @override
  Widget build(BuildContext context) {
    final debtorList = context
            .read<DebtorListCubit>()
            .state
            .debtorList
            ?.map((item) => SearchFieldListItem<String>(item.debtor))
            .toList() ??
        [];
    TextEditingController searchController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        const SizedBox(height: 24),
        SearchField(
          controller: searchController, // Add this controller
          suggestions: debtorList,
          hint: 'Search debtor',
          suggestionStyle: TextStyle(
            fontSize: 18,
            color: Colors.black.withOpacity(0.8),
          ),
          searchInputDecoration: SearchInputDecoration(
            // Fix: Use InputDecoration
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          maxSuggestionsInViewPort: 6,
          itemHeight: 50,
          onSuggestionTap: (SearchFieldListItem<String> suggestion) {
            searchController.text = suggestion.searchKey; // Update UI
            debtor = suggestion.searchKey; // Store selected value
          },
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MaterialButton(
              onPressed: () {
                context.read<SalesDataCubit>().onLoadingSalesData(debtor);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataScreen()),
                );
              },
              color: Colors.lightBlueAccent, // Background color
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 4), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Button border radius
              ),
              child: const Text(
                "Search",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
