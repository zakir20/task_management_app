import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../task_routes.dart';
import '../bloc/task_cubit.dart';
import '../bloc/task_state.dart';
import '../widgets/task_loading_shimmer.dart';
import '../widgets/task_category_filter.dart';
import 'package:task_management_app/injection/injection_container.dart';
import '../../../../core/navigation/app_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late TaskCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = TaskCubit(taskRepository: sl());
    _cubit.getTasks();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  String _getDynamicTime(int index) {
    int hour = 9 + (index ~/ 2);
    String period = hour >= 12 ? "PM" : "AM";
    int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    List<String> mins = [":00", ":15", ":30", ":45"];
    return "$displayHour${mins[index % 4]} $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              _buildHeader(),
              const Gap(25),
              _buildDateSection(),
              const Gap(25),
              
              BlocBuilder<TaskCubit, TaskState>(
                bloc: _cubit,
                buildWhen: (prev, curr) => curr is TaskLoaded,
                builder: (context, state) {
                  if (state is TaskLoaded) {
                    return TaskCategoryFilter(
                      selectedCategory: state.selectedCategory,
                      cubit: _cubit,
                    );
                  }
                  return const SizedBox(height: 38); 
                },
              ),
              
              const Gap(20),
              Expanded(child: _buildTaskList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        onPressed: () => AppRouter.push(context, TaskRoutes.addTask, extra: _cubit),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=livia'),
        ),
        const Gap(15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Hello!", 
              style: TextStyle(color: AppColors.textGrey, fontSize: 14),
            ),
            Text(
              "Livia Vaccaro", 
              style: TextStyle(
                color: AppColors.textBlack, 
                fontSize: 18, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "today's tasks", 
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: AppColors.textBlack,
          ),
        ),
        const Gap(15),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              DateTime date = DateTime.now().add(Duration(days: index - 2));
              bool isSelected = index == 2; 
              return Container(
                width: 65,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateHelper.formatMonth(date), 
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textGrey, 
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      DateHelper.formatDay(date), 
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textBlack, 
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateHelper.formatWeekday(date), 
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textGrey, 
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return BlocBuilder<TaskCubit, TaskState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is TaskLoading) return const TaskLoadingShimmer();
        
        if (state is TaskError) return Center(child: Text(state.message));
        
        if (state is TaskLoaded) {
          if (state.tasks.isEmpty) {
            return const Center(child: Text("No tasks available"));
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ID: ${task.id}", 
                            style: const TextStyle(color: AppColors.textGrey, fontSize: 11),
                          ),
                          Text(
                            task.todo, 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis, 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const Gap(5),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: AppColors.primary),
                              const Gap(5),
                              Text(
                                _getDynamicTime(index),
                                style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: task.completed 
                            ? AppColors.doneGreen.withOpacity(0.1) 
                            : AppColors.todoPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task.completed ? "Done" : "To-do", 
                        style: TextStyle(
                          color: task.completed ? AppColors.doneGreen : AppColors.todoPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}