import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/search_all_results.dart';
import '../widgets/search_doctor_results.dart';
import '../widgets/search_agenda_results.dart';
import '../widgets/search_service_results.dart';
import 'search_app_bar.dart';

final globalSearchQueryProvider = StateProvider<String>((ref) => '');

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.text = ref.read(globalSearchQueryProvider);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(globalSearchQueryProvider).toLowerCase();

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: SearchAppBar(
        searchController: _searchController,
        tabController: _tabController,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SearchAllResults(query: query),
          SearchDoctorResults(query: query),
          SearchAgendaResults(query: query),
          SearchServiceResults(query: query),
        ],
      ),
    );
  }
}
