// ignore_for_file: prefer_const_constructors, unused_import, must_be_immutable, unused_local_variable, avoid_print

// import 'dart:developer';

import 'dart:developer';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:expense_tracker/add_expenses.dart';
import 'package:expense_tracker/controllers/add_expens.dart';
import 'package:expense_tracker/modal.dart';
import 'package:expense_tracker/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    log('build 2');
    final controller = Provider.of<AddExpenseController>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          SizedBox(height: height * 0.2),
          // Consumer<AddExpenseController>(
          //   builder: (context, value, child) {
          //     return SfCircularChart(
          //       title: ChartTitle(text: 'Pie Chart'),
          //       legend: Legend(isVisible: true),
          //       series: [
          //         PieSeries(
          //           radius: '40%',
          //           dataSource: controller.data,
          //           xValueMapper: (dynamic data, int index) =>
          //               value.income.toString(),
          //           yValueMapper: (dynamic data, int index) => value.amount,
          //         ),
          //       ],
          //     );
          //   },
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.6,
                height: height * 0.07,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.income != null && controller.income!.isNotEmpty
                        ? Consumer<AddExpenseController>(
                            builder: (context, value, child) {
                              print('income');
                              return Text(
                                'Income: ${value.totalIncome}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          )
                        : Text(
                            'Income: 0',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    SizedBox(height: 5),
                    controller.expenses != null &&
                            controller.expenses!.isNotEmpty
                        ? Consumer<AddExpenseController>(
                            builder: (context, value, child) {
                              print('expense');
                              return Text(
                                'Expenses: ${value.totalExpenses}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          )
                        : Text(
                            'Expenses: 0',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Buttons(
                    buttonText: 'Add',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddExpenses(),
                      ),
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 5.0),
                  Buttons(
                    buttonText: 'Delete',
                    onPressed: () => controller.delete(),
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          ShowData(),
        ],
      ),
    );
  }
}

class ShowData extends StatelessWidget {
  const ShowData({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final controller = Provider.of<AddExpenseController>(context);
    ('build show data');
    return controller.data!.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              itemCount: controller.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SwipeActionCell(
                    key: ObjectKey(controller.data![index]),
                    trailingActions: <SwipeAction>[
                      SwipeAction(
                        title: "delete",
                        onTap: (CompletionHandler handler) async {
                          controller.deleteAt(index);
                        },
                        color: Colors.red,
                      ),
                    ],
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Consumer<AddExpenseController>(
                            builder: (context, value, child) {
                              print('show data');
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                width: width * 0.15,
                                height: height * 0.15,
                                child: value.data![index].typeOfAmount ==
                                        'Expenses'
                                    ? Icon(
                                        Icons.arrow_back,
                                        color: Colors.red,
                                        size: 25.0,
                                      )
                                    : Icon(
                                        Icons.arrow_forward,
                                        color: Colors.green,
                                        size: 25.0,
                                      ),
                              );
                            },
                          ),
                          SizedBox(
                            width: width * 0.5,
                            // color: Colors.grey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer<AddExpenseController>(
                                  builder: (context, value, child) {
                                    print('title');
                                    return Text(
                                      value.data![index].title!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 4.0),
                                Consumer<AddExpenseController>(
                                  builder: (context, value, child) {
                                    print('description');
                                    return Text(
                                      value.data![index].description!,
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 2.0),
                                Consumer<AddExpenseController>(
                                  builder: (context, value, child) {
                                    print('date');
                                    return Text(
                                      '${value.data![index].selectedDate!} at ${value.data![index].selectedTime!}',
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 12.0,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * 0.2,
                            child: Center(
                              child: Consumer<AddExpenseController>(
                                builder: (context, value, child) {
                                  print('time');
                                  return Text(
                                    value.data![index].amount!.toString(),
                                    softWrap: true,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : Center(
            child: Text(
              'Nothing to show.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          );
  }
}
