import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prova1/database/entities/series.dart';
import 'package:provider/provider.dart';

import '../repository/databaseRepository.dart';

class ShowDatabase extends StatefulWidget {
  const ShowDatabase({Key? key}) : super(key: key);

  @override
  State<ShowDatabase> createState() => _ShowDatabaseState();
}

// this page show us all our Series using a listTile
class _ShowDatabaseState extends State<ShowDatabase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        title: const Text('Le tue serie'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[600],
      ),
      body: Center(
        child: Consumer<DatabaseRepository>(builder: (context, dbr, child) {
          return FutureBuilder(
            initialData: null,
            future: dbr.findAllSeries(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as List<Series>;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, seriesIndex) {
                      final series = data[seriesIndex];
                      return Card(
                        elevation: 5,
                        //Here we use a Dismissible widget to create a nicer UI.
                        child: Dismissible(
                          //Just create a dummy unique key
                          key: UniqueKey(),
                          //This is the background to show when the ListTile is swiped
                          background: Container(
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: const Icon(Icons.delete),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),

                          //The ListTile is used to show the Todo entry
                          child: ListTile(
                            leading: const Icon(
                              Icons.fitness_center_outlined,
                              color: Colors.black,
                              size: 35,
                            ),
                            title: Text(
                              'Serie: ${series.id}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                'reps: ${series.reps};    acc: ${series.meanAcc};   tempo_mean: ${series.meanTime}'),
                            //If the ListTile is tapped, it is deleted
                          ),
                          //This method is called when the ListTile is dismissed
                          onDismissed: (direction) async {
                            //No need to use a Consumer, we are just using a method of the DatabaseRepository
                            await Provider.of<DatabaseRepository>(context,
                                    listen: false)
                                .removeSeries(series);
                          },
                        ),
                      );
                    });
              } else {
                //A CircularProgressIndicator is shown while the list of Todo is loading.
                return const CircularProgressIndicator();
              } //else
            }, //builder of FutureBuilder
          );
        }),
      ),
    );
  }
}
