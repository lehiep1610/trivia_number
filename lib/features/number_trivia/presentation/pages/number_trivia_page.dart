import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';
import 'package:trivia_number/features/number_trivia/presentation/widgets/custom_button.dart';
import 'package:trivia_number/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottom(context),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const CustomButton(
                title: 'Search',
              ),
              CustomButton(
                title: 'Get random Trivia',
                backgroundColor: Colors.grey[300],
                textColor: Colors.black87,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return BlocProvider(
      create: (_) => sl.get<NumberTriviaBloc>(),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text('Fixed Button'),
          ),
          Expanded(
            child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
              SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [],
                  )),
              SliverFillRemaining(
                hasScrollBody: true,
                child: Container(
                  color: Colors.red,
                  width: 100,
                  height: 100,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
