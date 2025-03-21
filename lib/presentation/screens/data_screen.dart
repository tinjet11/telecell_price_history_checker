import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/bloc/cubit/sales_data_cubit.dart';
import '../../main.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<SalesDataCubit, SalesDataState>(
        builder: (context, state) {
          if (state is SalesDataLoading) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.lightBlueAccent,
                title: Text(
                  BlocProvider.of<SalesDataCubit>(context).state.debtor,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => {
                          Navigator.pop(context),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainApp()),
                          ),
                        }),
                backgroundColor: Colors.lightBlueAccent,
                title: Text(
                  BlocProvider.of<SalesDataCubit>(context).state.debtor,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    if (BlocProvider.of<SalesDataCubit>(context)
                        .state
                        .salesData
                        .isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text("No data to be displayed")),
                      )
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Stock Code')),
                              DataColumn(label: Text('Stock FullName')),
                              DataColumn(label: Text('Unit Price')),
                              DataColumn(label: Text('Quantity')),
                              DataColumn(label: Text('Invoice')),
                              DataColumn(label: Text('Debtor')),
                            ],
                            rows: BlocProvider.of<SalesDataCubit>(context)
                                .state
                                .salesData
                                .map((data) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(data.date)),
                                  DataCell(Text(data.stockcode)),
                                  DataCell(Text(data.stockfullname)),
                                  DataCell(Text(data.unitprice)),
                                  DataCell(Text(data.quantity.toString())),
                                  DataCell(Text(data.invoice)),
                                  DataCell(Text(data.debtor)),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
