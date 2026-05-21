import '../../../../core_import.dart';

class HostProfileDrawer extends StatelessWidget {
  const HostProfileDrawer({super.key});

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
              padding: HostPadding.drawerHeader(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: context.r(mobile: 36),
                    backgroundColor: Colors.white24,
                    child: Icon(
                      HostIcons.profile,
                      color: Colors.white,
                      size: context.sp(mobile: 40),
                    ),
                  ),
                  SizedBox(height: context.h(mobile: 14)),
                  Text('Host', style: HostTextStyles.drawerName(context)),
                  SizedBox(height: context.h(mobile: 4)),
                  Text(
                    'HOST001',
                    style: HostTextStyles.drawerSubtitle(context),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.h(mobile: 16)),

            _DrawerItem(
              icon: HostIcons.drawerRole,
              label: 'Role',
              value: 'Host',
            ),
            _DrawerItem(
              icon: HostIcons.drawerScannerId,
              label: 'Scanner ID',
              value: 'HOST001',
            ),
            _DrawerItem(
              icon: HostIcons.drawerStatus,
              label: 'Status',
              value: 'Active',
              valueColor: HostColors.greenText,
            ),

            const Divider(height: 32, indent: 20, endIndent: 20),

            ListTile(
              leading: Icon(
                HostIcons.drawerLogout,
                color: HostColors.cornerRed,
                size: context.sp(mobile: 22),
              ),
              title: Text(
                'Logout',
                style: HostTextStyles.drawerLogout(context),
              ),
              onTap: () {
                Navigator.pop(context);
                context.router.replace(const UserIdRoute());
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
      padding: HostPadding.drawerItem(context),
      child: Row(
        children: [
          Icon(icon, color: HostColors.textMuted, size: context.sp(mobile: 22)),
          SizedBox(width: context.w(mobile: 14)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: HostTextStyles.drawerItemLabel(context)),
              SizedBox(height: context.h(mobile: 2)),
              Text(
                value,
                style: HostTextStyles.drawerItemValue(
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
