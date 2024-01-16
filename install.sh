# Shell script to install prshabboszman locally
# Run with root priveliges
# Run inside prshabboszman directory
#! /bin/sh
mv ../prshabboszman /usr/local/lib/prshabboszman				# Move directory containing git repository to /usr/local/lib/
chown -R root:wheel /usr/local/lib/prshabboszman				# Change owner to root and group to wheel
chmod -R a+rx /usr/local/lib/prshabboszman					# Add read and execute permissions for all users
chmod -R g+w /usr/local/lib/prshabboszman					# Add write permissions for members of the wheel group
ln -s /usr/local/lib/prshabboszman/prshabboszman.sh /usr/local/bin/psz		# Create symbolic link to prshabboszman.sh in /usr/local/bin/ called psz
