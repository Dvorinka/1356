import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../bootstrap/env.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/goal_model.dart';
import '../../../data/models/goal_step_model.dart';
import '../../../data/providers/image_search_provider.dart';
import '../../../data/providers/pexels_image_search_provider.dart';
import '../../../data/services/image_search_service.dart';
import '../../../data/services/pexels_image_search_service.dart';
import '../application/goals_controller.dart';
import 'location_picker_screen.dart';

enum OnlineImageSource { unsplash, pexels }

class LocationData {
  final double latitude;
  final double longitude;
  final String name;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.name,
  });
}

class GoalEditScreen extends ConsumerStatefulWidget {
  final String? goalId;

  const GoalEditScreen({super.key, this.goalId});

  @override
  ConsumerState<GoalEditScreen> createState() => _GoalEditScreenState();
}

class _GoalEditScreenState extends ConsumerState<GoalEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepController = TextEditingController();
  int _progress = 0;
  bool _isLoading = false;
  final List<GoalStep> _steps = [];
  final Uuid _uuid = const Uuid();
  
  LocationData? _selectedLocation;
  bool _isGettingLocation = false;
  
  String? _selectedImagePath;
  final ImagePicker _imagePicker = ImagePicker();
  
  List<UnsplashImage> _unsplashResults = [];
  List<PexelsImage> _pexelsResults = [];
  bool _isSearchingImages = false;
  late OnlineImageSource _selectedImageSource;
  final TextEditingController _imageSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (Env.unsplashEnabled) {
      _selectedImageSource = OnlineImageSource.unsplash;
    } else if (Env.pexelsEnabled) {
      _selectedImageSource = OnlineImageSource.pexels;
    } else {
      _selectedImageSource = OnlineImageSource.unsplash;
    }
    if (widget.goalId != null) {
      _loadGoal();
    }
  }

  void _loadGoal() {
    final goalsState = ref.read(goalsControllerProvider);
    if (goalsState.goals.isNotEmpty) {
      final goal = goalsState.goals.firstWhere((g) => g.id == widget.goalId);
      _titleController.text = goal.title;
      _descriptionController.text = goal.description ?? '';
      _progress = goal.progress;
      
      if (goal.hasLocation) {
        _selectedLocation = LocationData(
          latitude: goal.locationLat!,
          longitude: goal.locationLng!,
          name: goal.locationName ?? 'Selected Location',
        );
      }
      
      if (goal.hasImage) {
        _selectedImagePath = goal.imageUrl;
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Online'),
              enabled: Env.unsplashEnabled || Env.pexelsEnabled,
              onTap: (Env.unsplashEnabled || Env.pexelsEnabled)
                  ? () {
                      Navigator.pop(context);
                      _showImageSearchDialog();
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _imageSearchController,
                          decoration: const InputDecoration(
                            hintText: 'Search for images...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (query) {
                            _searchImages(query);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _searchImages(_imageSearchController.text);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Builder(
                    builder: (context) {
                      final segments = <ButtonSegment<OnlineImageSource>>[];
                      if (Env.unsplashEnabled) {
                        segments.add(const ButtonSegment(
                          value: OnlineImageSource.unsplash,
                          label: Text('Unsplash'),
                          icon: Icon(Icons.photo_library),
                        ));
                      }
                      if (Env.pexelsEnabled) {
                        segments.add(const ButtonSegment(
                          value: OnlineImageSource.pexels,
                          label: Text('Pexels'),
                          icon: Icon(Icons.collections),
                        ));
                      }

                      if (segments.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      if (!Env.unsplashEnabled && _selectedImageSource == OnlineImageSource.unsplash && Env.pexelsEnabled) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _selectedImageSource = OnlineImageSource.pexels;
                          });
                        });
                      }

                      if (!Env.pexelsEnabled && _selectedImageSource == OnlineImageSource.pexels && Env.unsplashEnabled) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _selectedImageSource = OnlineImageSource.unsplash;
                          });
                        });
                      }

                      return SegmentedButton<OnlineImageSource>(
                        segments: segments,
                        selected: {_selectedImageSource},
                        onSelectionChanged: (Set<OnlineImageSource> newSelection) {
                          setState(() => _selectedImageSource = newSelection.first);
                          if (_imageSearchController.text.isNotEmpty) {
                            _searchImages(_imageSearchController.text);
                          }
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
                Expanded(
                  child: _isSearchingImages
                      ? const Center(child: CircularProgressIndicator())
                      : (_unsplashResults.isEmpty && _pexelsResults.isEmpty)
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  'Search for images using keywords from your goal title',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: _selectedImageSource == OnlineImageSource.unsplash
                                  ? _unsplashResults.length
                                  : _pexelsResults.length,
                              itemBuilder: (context, index) {
                                if (_selectedImageSource == OnlineImageSource.unsplash) {
                                  final image = _unsplashResults[index];
                                  return GestureDetector(
                                    onTap: () => _selectUnsplashImage(image),
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            image.url,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                                child: const Icon(Icons.broken_image),
                                              );
                                            },
                                          ),
                                          if (image.photographer != null)
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.black.withValues(alpha: 0.7),
                                                    ],
                                                  ),
                                                ),
                                                child: Text(
                                                  'Photo by ${image.photographer}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  final image = _pexelsResults[index];
                                  return GestureDetector(
                                    onTap: () => _selectPexelsImage(image),
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            image.url,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                                child: const Icon(Icons.broken_image),
                                              );
                                            },
                                          ),
                                          if (image.photographer != null)
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.black.withValues(alpha: 0.7),
                                                    ],
                                                  ),
                                                ),
                                                child: Text(
                                                  'Photo by ${image.photographer}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _unsplashResults.clear();
                            _pexelsResults.clear();
                            _imageSearchController.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clearImage() {
    setState(() => _selectedImagePath = null);
  }

  Future<void> _searchImages(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() {
      _isSearchingImages = true;
      _unsplashResults.clear();
      _pexelsResults.clear();
    });
    
    try {
      if (_selectedImageSource == OnlineImageSource.unsplash) {
        final imageSearchService = ref.read(imageSearchServiceProvider);
        final results = await imageSearchService.searchImages(
          query: query,
          perPage: 10,
          orientation: 'landscape',
        );
        setState(() => _unsplashResults = results);
      } else {
        final pexelsService = ref.read(pexelsImageSearchServiceProvider);
        final results = await pexelsService.searchImages(
          query: query,
          perPage: 10,
          orientation: 'landscape',
        );
        setState(() => _pexelsResults = results);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching images: $e')),
        );
      }
    } finally {
      setState(() => _isSearchingImages = false);
    }
  }

  void _selectUnsplashImage(UnsplashImage image) {
    setState(() {
      _selectedImagePath = image.url;
      _unsplashResults.clear();
      _pexelsResults.clear();
      _imageSearchController.clear();
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _selectPexelsImage(PexelsImage image) {
    setState(() {
      _selectedImagePath = image.url;
      _unsplashResults.clear();
      _pexelsResults.clear();
      _imageSearchController.clear();
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled')),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are permanently denied')),
          );
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _selectedLocation = LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          name: 'Current Location',
        );
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  Future<void> _openLocationPicker() async {
    final result = await context.push<LocationPickerResult>('/location-picker');
    
    if (result != null) {
      setState(() {
        _selectedLocation = LocationData(
          latitude: result.position.latitude,
          longitude: result.position.longitude,
          name: result.address,
        );
      });
    }
  }

  void _clearLocation() {
    setState(() => _selectedLocation = null);
  }

  void _addStep() {
    if (_stepController.text.trim().isEmpty) return;
    
    setState(() {
      _steps.add(GoalStep(
        id: _uuid.v4(),
        goalId: widget.goalId ?? '',
        title: _stepController.text.trim(),
        isDone: false,
        orderIndex: _steps.length,
        createdAt: DateTime.now(),
      ));
      _stepController.clear();
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
      for (int i = 0; i < _steps.length; i++) {
        _steps[i] = _steps[i].copyWith(orderIndex: i);
      }
    });
  }

  void _toggleStepCompletion(int index) {
    setState(() {
      _steps[index] = _steps[index].copyWith(isDone: !_steps[index].isDone);
      final completedSteps = _steps.where((s) => s.isDone).length;
      _progress = _steps.isEmpty ? 0 : ((completedSteps / _steps.length) * 100).round();
    });
  }

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final goal = Goal(
        id: widget.goalId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        ownerId: 'current_user_id',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        progress: _progress,
        locationLat: _selectedLocation?.latitude,
        locationLng: _selectedLocation?.longitude,
        locationName: _selectedLocation?.name,
        imageUrl: _selectedImagePath,
        completed: _progress == 100,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.goalId != null) {
        await ref.read(goalsControllerProvider.notifier).updateGoal(goal);
      } else {
        await ref.read(goalsControllerProvider.notifier).createGoal(goal);
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving goal: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepController.dispose();
    _imageSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.goalId == null ? 'Create Goal' : 'Edit Goal',
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  label: 'Goal title field',
                  hint: 'Enter your goal title',
                  child: TextFormField(
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Goal Title *',
                      hintText: 'e.g., Learn to play guitar',
                      prefixIcon: Icon(Icons.flag_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: Validators.validateGoalTitle,
                    enabled: !_isLoading,
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Goal description field',
                  hint: 'Enter a description for your goal',
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'What do you want to achieve?',
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: Validators.validateGoalDescription,
                    enabled: !_isLoading,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Cover Image (Optional)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                if (_selectedImagePath == null)
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _showImagePickerDialog,
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Add Image'),
                  )
                else
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImagePath!.startsWith('http')
                              ? File('')
                              : File(_selectedImagePath!),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              child: const Center(
                                child: Icon(Icons.broken_image),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                          onPressed: _clearImage,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                Text(
                  'Location (Optional)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                if (_selectedLocation == null)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isGettingLocation ? null : _getCurrentLocation,
                          icon: _isGettingLocation
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.my_location),
                          label: const Text('Use Current Location'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _openLocationPicker,
                          icon: const Icon(Icons.map),
                          label: const Text('Pick on Map'),
                        ),
                      ),
                    ],
                  )
                else
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(_selectedLocation!.name),
                      subtitle: Text(
                        '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearLocation,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  'Progress: $_progress%',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _progress.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: '$_progress%',
                  onChanged: (value) {
                    setState(() => _progress = value.toInt());
                  },
                ),
                Text(
                  'Milestones/Steps',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _stepController,
                        decoration: const InputDecoration(
                          labelText: 'Add a step',
                          hintText: 'e.g., Complete first draft',
                          prefixIcon: Icon(Icons.add_task_outlined),
                          border: OutlineInputBorder(),
                        ),
                        enabled: !_isLoading,
                        onSubmitted: (_) => _addStep(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _isLoading ? null : _addStep,
                      icon: const Icon(Icons.add_circle),
                      iconSize: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_steps.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'No steps added yet. Add steps to track your progress.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  )
                else
                  ...List.generate(_steps.length, (index) {
                    final step = _steps[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Checkbox(
                          value: step.isDone,
                          onChanged: _isLoading
                              ? null
                              : (_) => _toggleStepCompletion(index),
                        ),
                        title: Text(
                          step.title,
                          style: TextStyle(
                            decoration: step.isDone
                                ? TextDecoration.lineThrough
                                : null,
                            color: step.isDone
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: _isLoading
                              ? null
                              : () => _removeStep(index),
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                PrimaryButton(
                  onPressed: _isLoading ? () {} : _saveGoal,
                  text: _isLoading ? 'Saving...' : 'Save Goal',
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
