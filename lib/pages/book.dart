import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
    DateTime _selectedDay = DateTime.now().add(const Duration(days: 1));
    DateTime _focusedDay = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.brown,
        title: const Text(
          "Book a tour",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Number of people',
                  label: Text('How many people are you coming with?'),
                ),
              ),
              TableCalendar(
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                firstDay: DateTime.now().add(const Duration(days: 1)),
                lastDay: DateTime.now().add(const Duration(days: 14)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay =
                        focusedDay; // update `_focusedDay` here as well
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: (){}, child: const Text('7 AM'),),
                   OutlinedButton(onPressed: (){}, child: const Text('8 AM'),),
                    OutlinedButton(onPressed: (){}, child: const Text('9 AM'),),
                    OutlinedButton(onPressed: (){}, child: const Text('10 AM'),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: (){}, child: const Text('11 AM'),),
                   OutlinedButton(onPressed: (){}, child: const Text('12 PM'),),
                    OutlinedButton(onPressed: (){}, child: const Text('1 PM'),),
                    OutlinedButton(onPressed: (){}, child: const Text('2 PM'),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: (){}, child: const Text('3 PM'),),
                   OutlinedButton(onPressed: (){}, child: const Text('4 PM'),),
                    OutlinedButton(onPressed: (){}, child: const Text('5 PM'),),
                    OutlinedButton(onPressed: (){}, child: const Text('6 PM'),),
                ],
              ),
              ElevatedButton(
                  onPressed: () {}, child: const Text('Request Tour')),
            ],
          ),
        ),
      ),
    );
  }
}
