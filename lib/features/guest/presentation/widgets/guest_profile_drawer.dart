import '../../../../core_import.dart';

class GuestProfileDrawer extends StatelessWidget {
  final String userId;
  const GuestProfileDrawer({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.blue,
              padding: GuestPadding.drawerHeader(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: context.r(mobile: 36),
                    backgroundColor: Colors.white24,
                    child: Icon(
                      GuestIcons.profile,
                      color: Colors.white,
                      size: context.sp(mobile: 40),
                    ),
                  ),
                  SizedBox(height: context.h(mobile: 14)),
                  Text('Guest', style: GuestTextStyles.drawerName(context)),
                  SizedBox(height: context.h(mobile: 4)),
                  Text(userId, style: GuestTextStyles.drawerSubtitle(context)),
                ],
              ),
            ),

            SizedBox(height: context.h(mobile: 16)),

            _DrawerItem(
              icon: GuestIcons.drawerRole,
              label: 'Role',
              value: 'Guest',
            ),
            _DrawerItem(
              icon: GuestIcons.drawerGuestId,
              label: 'Guest ID',
              value: userId,
            ),
            _DrawerItem(
              icon: GuestIcons.drawerStatus,
              label: 'Status',
              value: 'Active',
              valueColor: GuestColors.drawerActiveText,
            ),

            const Divider(height: 32, indent: 20, endIndent: 20),

            ListTile(
              leading: Icon(
                GuestIcons.drawerLogout,
                color: GuestColors.drawerLogoutIcon,
                size: context.sp(mobile: 22),
              ),
              title: Text(
                'Logout',
                style: GuestTextStyles.drawerLogout(context),
              ),
              onTap: () {
                Navigator.pop(context); // close drawer first
                context.router.replace(const UserIdRoute());
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Single detail row ────────────────────────────────────────────────────────
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: GuestPadding.drawerItem(context),
      child: Row(
        children: [
          Icon(
            icon,
            color: GuestColors.drawerTextMuted,
            size: context.sp(mobile: 22),
          ),
          SizedBox(width: context.w(mobile: 14)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GuestTextStyles.drawerItemLabel(context)),
              SizedBox(height: context.h(mobile: 2)),
              Text(
                value,
                style: GuestTextStyles.drawerItemValue(
                  context,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
