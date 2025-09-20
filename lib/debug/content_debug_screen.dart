import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../application/providers/content_list_provider.dart';
import '../application/providers/network_connectivity_provider.dart';

class ContentDebugScreen extends ConsumerWidget {
  const ContentDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Debug'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Auth Status: ${user != null ? "Signed In" : "Not Signed In"}'),
            if (user != null) Text('User ID: ${user.uid}'),
            const SizedBox(height: 20),
            
            // Test direct Firestore query
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('content')
                  .limit(1)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Direct Firestore: Loading...');
                }
                if (snapshot.hasError) {
                  return Text('Direct Firestore Error: ${snapshot.error}');
                }
                return Text('Direct Firestore: ${snapshot.data?.docs.length ?? 0} documents found');
              },
            ),
            
            const SizedBox(height: 20),
            
            // Test real-time provider
            Consumer(
              builder: (context, ref, child) {
                // Try to get a known content ID first
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('content')
                      .limit(1)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Finding content ID...');
                    }
                    if (snapshot.hasError || snapshot.data?.docs.isEmpty == true) {
                      return Text('No content found: ${snapshot.error}');
                    }
                    
                    final contentId = snapshot.data!.docs.first.id;
                    final contentAsync = ref.watch(realTimeContentDetailProvider(contentId));
                    
                    return contentAsync.when(
                      loading: () => const Text('Real-time Provider: Loading...'),
                      error: (error, stack) => Text('Real-time Provider Error: $error'),
                      data: (content) => Text('Real-time Provider: ${content != null ? "Content loaded" : "Content is null"}'),
                    );
                  },
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Test network connectivity
            Consumer(
              builder: (context, ref, child) {
                try {
                  final isOffline = ref.watch(isOfflineProvider);
                  return Text('Network Status: ${isOffline ? "Offline" : "Online"}');
                } catch (e) {
                  return Text('Network Status Error: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}