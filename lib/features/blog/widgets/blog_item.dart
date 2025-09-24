import 'package:flutter/material.dart';
import '../model/blog_model.dart';
import '../screen/blog_details_screen.dart';
import 'package:intl/intl.dart';

class BlogItem extends StatelessWidget {
  final Blog blog;

  const BlogItem({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    BlogDetailsScreen(blog: blog), // pass the full Blog object
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  blog.image != null && blog.image!.isNotEmpty
                      ? Image.network(
                        blog.image!,
                        height: 100,
                        width: 140,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        height: 100,
                        width: 140,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),

            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      blog.subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.grey[400],
                          backgroundImage:
                              blog.authorImg != null &&
                                      blog.authorImg!.isNotEmpty
                                  ? NetworkImage(blog.authorImg!)
                                  : null,
                          child:
                              (blog.authorImg == null ||
                                      blog.authorImg!.isEmpty)
                                  ? const Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            blog.author,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Published ${blog.date.toLocal().toString().split(' ')[0]}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.right,
                          ),

                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
