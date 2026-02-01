import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/task_cubit.dart';

class TaskCategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final TaskCubit cubit;

  const TaskCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = TaskCubit.categories;

    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final bool isSelected = selectedCategory == tabs[index];
          return GestureDetector(
            onTap: () => cubit.filterTasks(tabs[index]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade200,
                ),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}