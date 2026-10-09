import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../theme.dart';
import '../util/location.dart';

/// A place picked on the map.
class PickedPlace {
  final double lat;
  final double lng;
  final String name;
  const PickedPlace(this.lat, this.lng, this.name);
}

/// Full-screen map: tap or drag the pin to place it, then name the place.
class LocationPickerScreen extends StatefulWidget {
  final PickedPlace? initial;
  const LocationPickerScreen({super.key, this.initial});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late LatLng _pin;
  late final TextEditingController _name;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _pin = initial != null
        ? LatLng(initial.lat, initial.lng)
        : const LatLng(28.6315, 77.2167);
    _name = TextEditingController(text: initial?.name ?? '');
    if (initial == null) _centerOnDevice();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  GoogleMapController? _map;

  Future<void> _centerOnDevice() async {
    final loc = await resolveBrowseLocation();
    if (!mounted || loc.isFallback) return;
    _move(LatLng(loc.lat, loc.lng));
  }

  /// Re-centres the map (and so the pin) on [to].
  void _move(LatLng to) {
    _pin = to;
    _map?.animateCamera(CameraUpdate.newLatLng(to));
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      PickedPlace(_pin.latitude, _pin.longitude, _name.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pick a location')),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: _pin, zoom: 15),
                  onMapCreated: (c) => _map = c,
                  // The pin stays in the middle; the map moves under it.
                  onCameraMove: (p) => _pin = p.target,
                  onCameraIdle: () => setState(() {}),
                  onTap: _move,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
                const IgnorePointer(child: Center(child: _CenterPin())),
                Positioned(
                  top: Gap.md,
                  left: Gap.md,
                  right: Gap.md,
                  child: Material(
                    color: colors.surface.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(12),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Gap.md,
                        vertical: Gap.sm + 2,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.touch_app_outlined, color: colors.primary),
                          const SizedBox(width: Gap.sm),
                          Expanded(
                            child: Text(
                              'Drag the map or tap a spot to place the pin.',
                              style: text.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(Gap.md),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 120,
                      decoration: const InputDecoration(
                        labelText: 'Place name',
                        hintText: 'e.g. Café Lota, Pragati Maidan',
                        prefixIcon: Icon(Icons.place_outlined),
                        counterText: '',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Give the place a name people will recognise'
                          : null,
                      onFieldSubmitted: (_) => _confirm(),
                    ),
                    const SizedBox(height: Gap.sm + 4),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _confirm,
                        child: const Text('Use this location'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A map pin whose tip sits exactly on the centre of its parent.
class _CenterPin extends StatelessWidget {
  const _CenterPin();

  static const _size = 48.0;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -_size / 2),
      child: Icon(
        Icons.location_on,
        size: _size,
        color: Theme.of(context).colorScheme.primary,
        shadows: const [Shadow(blurRadius: 6, color: Colors.black26)],
      ),
    );
  }
}
