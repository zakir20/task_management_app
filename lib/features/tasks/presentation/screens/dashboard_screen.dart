import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/task_cubit.dart';
import '../bloc/task_state.dart';
import '../../task_routes.dart';
import '../widgets/task_loading_shimmer.dart'; 
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeTabIndex = 0; 

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().getTasks();
  }

  String _getDynamicTime(int index) {
    int hour = 9 + (index ~/ 2); 
    String period = hour >= 12 ? "PM" : "AM";
    int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    List<String> mins = [":00", ":15", ":30", ":45"];
    String min = mins[index % 4];
    
    return "$displayHour$min $period";
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
              _buildCategoryTabs(),
              const Gap(20),
              Expanded(child: _buildTaskList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        onPressed: () => context.push(TaskRoutes.addTask),
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
          children: [
            Text("Hello!", style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 14)),
            Text("Livia Vaccaro", style: GoogleFonts.poppins(color: AppColors.textBlack, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's tasks", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textBlack)),
        const Gap(15),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              DateTime date = DateTime.now().add(Duration(days: index - 2));
              bool isSelected = index == 2; 
              return Container(
                width: 65,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))] : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('MMM').format(date), style: GoogleFonts.poppins(color: isSelected ? Colors.white : AppColors.textGrey, fontSize: 12)),
                    Text(date.day.toString(), style: GoogleFonts.poppins(color: isSelected ? Colors.white : AppColors.textBlack, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(DateFormat('E').format(date), style: GoogleFonts.poppins(color: isSelected ? Colors.white : AppColors.textGrey, fontSize: 12)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    List<String> tabs = ["All", "To do", "In Progress", "Completed"];
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          bool isSelected = _activeTabIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => _activeTabIndex = index);
              context.read<TaskCubit>().filterTasks(tabs[index]);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : AppColors.textGrey, 
                    fontSize: 13, 
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskList() {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const TaskLoadingShimmer();
        }

        if (state is TaskError) {
          return Center(child: Text(state.message));
        }

        if (state is TaskLoaded) {
          if (state.tasks.isEmpty) {
            return const Center(child: Text("No tasks available"));
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              final String dynamicTime = _getDynamicTime(index);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID: ${task.id}", style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 11)),
                          Text(
                            task.todo, 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis, 
                            style: GoogleFonts.poppins(color: AppColors.textBlack, fontWeight: FontWeight.bold, fontSize: 15)
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: AppColors.primary),
                              const Gap(5),
                              Text(dynamicTime, style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: task.completed ? AppColors.doneGreen.withOpacity(0.1) : AppColors.todoPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task.completed ? "Done" : "To-do",
                        style: GoogleFonts.poppins(
                          color: task.completed ? AppColors.doneGreen : AppColors.todoPurple, 
                          fontSize: 11, 
                          fontWeight: FontWeight.bold
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