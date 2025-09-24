import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'simple_room_screen.dart';

class SearchRoomsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allRooms;

  SearchRoomsScreen({required this.allRooms});

  @override
  State<SearchRoomsScreen> createState() => _SearchRoomsScreenState();
}

class _SearchRoomsScreenState extends State<SearchRoomsScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredRooms = [];
  String _selectedCategory = 'All';
  String _sortBy = 'Name';
  bool _showActiveOnly = false;

  final List<String> _categories = ['All', 'General', 'Music', 'Study', 'Tech', 'Entertainment'];
  final List<String> _sortOptions = ['Name', 'Participants', 'Recent'];

  @override
  void initState() {
    super.initState();
    _filteredRooms = List.from(widget.allRooms);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterRooms();
  }

  void _filterRooms() {
    setState(() {
      _filteredRooms = widget.allRooms.where((room) {
        final matchesSearch = room['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
            room['description'].toLowerCase().contains(_searchController.text.toLowerCase());
        
        final matchesCategory = _selectedCategory == 'All' || 
            room['name'].toLowerCase().contains(_selectedCategory.toLowerCase());
        
        final isActive = !_showActiveOnly || room['total_participants'] > 0;
        
        return matchesSearch && matchesCategory && isActive;
      }).toList();

      // Sort results
      if (_sortBy == 'Name') {
        _filteredRooms.sort((a, b) => a['name'].compareTo(b['name']));
      } else if (_sortBy == 'Participants') {
        _filteredRooms.sort((a, b) => b['total_participants'].compareTo(a['total_participants']));
      } else if (_sortBy == 'Recent') {
        // For demo, just shuffle the list
        _filteredRooms.shuffle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find Rooms',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1976D2),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16),
            color: Color(0xFF1E1E1E),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search rooms...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterRooms();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                
                SizedBox(height: 12),
                
                // Filters Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _categories.map((category) => 
                          DropdownMenuItem(value: category, child: Text(category))
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                          _filterRooms();
                        },
                      ),
                    ),
                    
                    SizedBox(width: 12),
                    
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sortBy,
                        decoration: InputDecoration(
                          labelText: 'Sort by',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _sortOptions.map((option) => 
                          DropdownMenuItem(value: option, child: Text(option))
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            _sortBy = value!;
                          });
                          _filterRooms();
                        },
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                
                // Active Only Toggle
                Row(
                  children: [
                    Checkbox(
                      value: _showActiveOnly,
                      onChanged: (value) {
                        setState(() {
                          _showActiveOnly = value!;
                        });
                        _filterRooms();
                      },
                      activeColor: Color(0xFF03DAC6),
                    ),
                    Text(
                      'Show active rooms only',
                      style: GoogleFonts.inter(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: _filteredRooms.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredRooms.length,
                    itemBuilder: (context, index) {
                      final room = _filteredRooms[index];
                      return _buildRoomCard(room);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF1976D2),
          child: Icon(
            Icons.groups,
            color: Colors.white,
          ),
        ),
        title: Text(
          room['name'],
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              room['description'],
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person, size: 14, color: Color(0xFF03DAC6)),
                SizedBox(width: 4),
                Text(
                  '${room['total_participants']} participants',
                  style: GoogleFonts.inter(
                    color: Color(0xFF03DAC6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Get.to(() => SimpleRoomScreen(
              roomName: room['name'],
              roomDescription: room['description'],
            ));
          },
          child: Text('Join'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF03DAC6),
            foregroundColor: Colors.black,
            minimumSize: Size(60, 30),
          ),
        ),
        onTap: () {
          Get.to(() => SimpleRoomScreen(
            roomName: room['name'],
            roomDescription: room['description'],
          ));
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No rooms found',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}