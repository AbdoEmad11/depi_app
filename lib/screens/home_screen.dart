import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/characters_cubit.dart';
import '../cubits/characters_state.dart';
import '../widgets/character_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize header animation
    _headerAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOut,
    ));

    _headerAnimationController.forward();

    // Load characters on screen init
    context.read<CharactersCubit>().loadCharacters();

    // Setup scroll controller for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<CharactersCubit>().loadMoreCharacters();
    }
  }

  void _onSearchChanged(String query) {
    // Debounce search
    Future.delayed(Duration(milliseconds: 500), () {
      if (_searchController.text == query) {
        context.read<CharactersCubit>().searchCharacters(query);
      }
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthCubit>().signOut();
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Animated Header
            FadeTransition(
              opacity: _headerAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, -1.0),
                  end: Offset.zero,
                ).animate(_headerAnimation),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header with logout
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Characters',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Rick and Morty Universe',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.primary),
                            onPressed: _logout,
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Search Bar
                      TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search characters...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xFF101010),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Characters List
            Expanded(
              child: BlocBuilder<CharactersCubit, CharactersState>(
                builder: (context, state) {
                  if (state is CharactersLoading && _searchController.text.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Loading characters...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is CharactersError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 80,
                            color: Colors.redAccent,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Oops! Something went wrong',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CharactersCubit>().loadCharacters();
                            },
                            child: Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is CharactersLoaded) {
                    if (state.characters.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: Colors.white24,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No characters found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try searching with a different name',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.characters.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.characters.length) {
                          // Loading indicator for pagination
                          return Container(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final character = state.characters[index];
                        return CharacterCard(
                          character: character,
                          index: index,
                        );
                      },
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}