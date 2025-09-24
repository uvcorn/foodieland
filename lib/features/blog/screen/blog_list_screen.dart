import 'package:flutter/material.dart';
import 'package:foodieland/features/blog/model/blog_model.dart';
import 'package:foodieland/features/blog/screen/blog_add_screen.dart';
import 'package:foodieland/features/blog/screen/login_popup_for_addpost.dart';
import 'package:foodieland/features/blog/widgets/blog_item.dart';
import 'package:foodieland/features/home/ui/screens/home_screen.dart';
import 'package:foodieland/utils/app_colors/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../blog_repository/blog_repo_function.dart';
import '../widgets/paging_widget.dart';

class BlogListPage extends StatefulWidget {
  BlogListPage({super.key});

  static final String routeName = '/blog-list';
  final repository = BlogRepository(supabase: Supabase.instance.client);

  @override
  State<BlogListPage> createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  bool isUserLoggedIn() {
    final user = Supabase.instance.client.auth.currentUser;
    return user != null;
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTotalBlogs();
    loadBlogs();
  }

  List<Blog> blogs = [];

  int totalBlogs = 0;
  int totalPages = 1;
  int currentPage = 1;
  int limit = 5;

  String searchQuery = ""; // 🔹   searchQuery ADD
  final TextEditingController searchController = TextEditingController();

  Future<void> loadBlogs({String searchQuery = ""}) async {
    final supabase = Supabase.instance.client;

    // Base query
    var query = supabase
        .from('blogs')
        .select()
        .order('date', ascending: false)
        .range((currentPage - 1) * limit, currentPage * limit - 1);

    // যদি searchQuery থাকে তাহলে filter চালাও
    if (searchQuery.isNotEmpty) {
      query = supabase
          .from('blogs')
          .select()
          .textSearch('title', searchQuery)
          .order('date', ascending: false)
          .range((currentPage - 1) * limit, currentPage * limit - 1);
    }

    final PostgrestList data = await query;

    setState(() {
      blogs = data.map((e) => Blog.fromMap(e)).toList();
      isLoading = false;
    });
  }

  Future<void> loadTotalBlogs() async {
    final supabase = Supabase.instance.client;

    // Step 1: select and get count
    final response = await supabase
        .from('blogs')
        .select('id')
        .count(CountOption.exact);

    // Step 2: get total count
    final total = response.count;

    setState(() {
      totalBlogs = total;
      totalPages = (totalBlogs / limit).ceil();
    });
  }

  // --Paging Function
  void goToPage(int page) {
    setState(() {
      currentPage = page;
      isLoading = true;
    });
    loadBlogs(searchQuery: searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () {
          if (isUserLoggedIn()) {
            //  user logged in → Blog add page
            Navigator.pushNamed(context, BlogPostScreen.routeName);
          } else {
            //  user not logged in →
            showLoginPopup(context);
          }
        },
      ),
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        elevation: 0,
        title: Text(
          "Blog & Article",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: _buildArticleList(context),
        ),
      ),
    );
  }

  Widget _buildArticleList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore",
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 16),

        // Search Box
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search article or recipe...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon:
                      searchController.text.isEmpty
                          ? null
                          : IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                searchQuery = "";
                                currentPage = 1;
                                isLoading = true;
                              });
                              loadBlogs(searchQuery: "");
                            },
                          ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),

            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  searchQuery = searchController.text;
                  currentPage = 1;
                  isLoading = true;
                });
                loadBlogs(
                  searchQuery: searchQuery,
                ); // ✅ এখানে searchQuery ব্যবহার
              },
              child: const Text("Search", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),

        const SizedBox(height: 24),

        //  Blog List
        Expanded(
          child: ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              return BlogItem(
                blog: blog, // blog Map
              );
            },
          ),
        ),

        // Pagination Bar
        const SizedBox(height: 16),

        PaginationWidget(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) {
            goToPage(page);
          },
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
