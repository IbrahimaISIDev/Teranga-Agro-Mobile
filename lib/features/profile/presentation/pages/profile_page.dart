import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teranga_agro/core/providers/locale_provider.dart';
import 'package:teranga_agro/features/dashboard/presentation/widgets/custom_bottom_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../main.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../domain/entities/user.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _regionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _regionController = TextEditingController();

    // Fetch user data on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false)
          .fetchUser()
          .then((_) {
        final user = Provider.of<ProfileProvider>(context, listen: false).user;
        if (user != null) {
          _nameController.text = user.name;
          _phoneController.text = user.phoneNumber;
          _regionController.text = user.region;
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final profileProvider = Provider.of<ProfileProvider>(context);
    final languageProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(loc.navProfile,
            style: AppTextStyles.heading3.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Profile Banner
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Information Section
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person_outline,
                                    color: AppColors.primary),
                                SizedBox(width: 8),
                                Text(
                                  loc.personalInfo,
                                  style: AppTextStyles.heading3,
                                ),
                              ],
                            ),
                            Divider(height: 24),
                            Consumer<ProfileProvider>(
                              builder: (context, provider, child) {
                                if (provider.isLoading) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.primary),
                                      ),
                                    ),
                                  );
                                }
                                if (provider.errorMessage != null) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.error_outline,
                                              color: Colors.red, size: 48),
                                          SizedBox(height: 8),
                                          Text(
                                            provider.errorMessage!,
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(color: Colors.red),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                if (provider.user == null) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.info_outline,
                                              color: Colors.grey, size: 48),
                                          SizedBox(height: 8),
                                          Text(
                                            loc.noData,
                                            style: AppTextStyles.bodyMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          labelText: loc.name,
                                          hintText: "Ex: John Doe",
                                          prefixIcon: Icon(Icons.badge,
                                              color: AppColors.primary),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: AppColors.primary,
                                                width: 2),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return loc.requiredField;
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: _phoneController,
                                        decoration: InputDecoration(
                                          labelText: loc.phoneNumber,
                                          hintText: "Ex: +221 77 123 45 67",
                                          prefixIcon: Icon(Icons.phone,
                                              color: AppColors.primary),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: AppColors.primary,
                                                width: 2),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                        ),
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return loc.requiredField;
                                          }
                                          if (!RegExp(r'^\+?[1-9]\d{1,14}$')
                                              .hasMatch(value)) {
                                            return loc.invalidPhoneNumber;
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: _regionController,
                                        decoration: InputDecoration(
                                          labelText: loc.region,
                                          hintText: "Ex: Dakar",
                                          prefixIcon: Icon(Icons.location_on,
                                              color: AppColors.primary),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: AppColors.primary,
                                                width: 2),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return loc.requiredField;
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: profileProvider.isLoading
                                              ? null
                                              : () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    final user = User(
                                                      id: provider.user!.id,
                                                      name:
                                                          _nameController.text,
                                                      phoneNumber:
                                                          _phoneController.text,
                                                      region: _regionController
                                                          .text,
                                                    );
                                                    final success =
                                                        await provider
                                                            .updateUser(user);
                                                    if (success) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(loc
                                                              .profileUpdated),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors.green,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(provider
                                                                  .errorMessage ??
                                                              loc.errorUpdatingProfile),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors.red,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: AppColors.primary,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            loc.save,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Preferences Section
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.settings, color: AppColors.primary),
                                SizedBox(width: 8),
                                Text(
                                  loc.preferences,
                                  style: AppTextStyles.heading3,
                                ),
                              ],
                            ),
                            Divider(height: 24),
                            // Language Preference
                            ListTile(
                              leading: Icon(Icons.language,
                                  color: AppColors.primary),
                              title: Text(loc.language,
                                  style: AppTextStyles.bodyMedium),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: DropdownButton<String>(
                                  value: languageProvider.locale.languageCode,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'fr', child: Text('Français')),
                                    DropdownMenuItem(
                                        value: 'wo', child: Text('Wolof')),
                                    DropdownMenuItem(
                                        value: 'en', child: Text('English')),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      languageProvider.setLocale(Locale(value));
                                    }
                                  },
                                  underline: SizedBox(),
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: AppColors.primary),
                                ),
                              ),
                            ),
                            // Theme Preference
                            ListTile(
                              leading: Icon(
                                themeProvider.themeMode == ThemeMode.light
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                                color: AppColors.primary,
                              ),
                              title: Text(loc.theme,
                                  style: AppTextStyles.bodyMedium),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: DropdownButton<String>(
                                  value:
                                      themeProvider.themeMode == ThemeMode.light
                                          ? 'light'
                                          : 'dark',
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'light', child: Text('Clair')),
                                    DropdownMenuItem(
                                        value: 'dark', child: Text('Sombre')),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      themeProvider.setThemeMode(
                                          value == 'light'
                                              ? ThemeMode.light
                                              : ThemeMode.dark);
                                    }
                                  },
                                  underline: SizedBox(),
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: AppColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.logout),
                        label: Text(loc.logout),
                        onPressed: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                title: Text("Confirmation"),
                                content: Text(
                                    "Êtes-vous sûr de vouloir vous déconnecter ?"),
                                actions: [
                                  TextButton(
                                    child: Text("Annuler"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text("Déconnexion"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.go('/main');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(loc.loggedOut),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    // Offline Status
                    if (profileProvider.isOffline)
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.wifi_off, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                loc.offlineMessage,
                                style: TextStyle(
                                    color: Colors.red[700], fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentIndex: 3, // Marketplace est à l'index 2
      ),
    );
  }
}
