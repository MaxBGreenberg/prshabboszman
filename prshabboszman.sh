# Shell script to print zmanim for shabbos of the current week to line printer
# (C) Copyright Max Greenberg 2023
# Licenced under GPLv2
# Uses hebcal and GNU date
# prshabboszman.sh is a UNIX shell script for printing shabbos zmanim
# It uses hebcal to determine zmanim and GNU date to get the date input into hebcal
# This came from a need to quickly print zmanim for Shabbos on Friday afternoon
# It will print select zmanim for the coming friday, all zmanimi for the comming saturday
# The Hebrew dates of both days and the week's parsha
# It prints today's and tomorrow's Hebrew dates
# and the current week's parsha
# It will run any day of the week
#!/bin/sh

SUPRESS_LP=false						# Set programme to print output to printer by default
SUPRESS_CAT=false						# Set porgamme to print output to terminal by default

# Process options
while getopts ":lc" opt; do					# Get options
	case $opt in
	l)							# If -l option is used
		SUPRESS_LP=true					# Supress printing to printer
		;;
	c)							# If -c option is used
		SUPRESS_CAT=true				# Supress printing to terminal
		;;
	\?)							# If invalid option is used
		echo "Invalid option: -$OPTARG" >&2		# Print error message to terminal
		exit 1						# And exit with error
	esac
done

shift $((OPTIND - 1))

DEFCITY='toronto'						# Sets default city for if no argument is passed
CITY="${@:-$DEFCITY}"						# Defines city we are calculating zmanim from standard input
FRI=$(date -dFriday '+%m %d %Y')				# Set varaible FRI to the date of Friday this week in format taken by hebcal
if [ "$(date +%u)" -eq 6 ]; then				# If today is Saturday
	SAT=$(date -d "next Saturday" '+%m %d %Y')		# Set variable SAT to the date of the following Saturday in format taken by hebcal
else								# If today is not Saturday
	SAT=$(date -dSaturday '+%m %d %Y')			# Set variable SAT to the date of Saturday this week in format taken by hebcal
fi

echo "Shabbos zmanim for "$CITY > /tmp/hebcal.tmp		# Prints city you're printing zmanim for
hebcal -SC "${CITY}" $FRI | grep -v Candle >> /tmp/hebcal.tmp	# Prints hebrew date of Erev Shabbos, parshas hashavua to file ~/hebcal.tmp
hebcal -ZC "${CITY}" $FRI | grep Plag >> /tmp/hebcal.tmp	# Print zman plag hamincha for Erev Shabbos to the same file
hebcal -ZcC "${CITY}" $FRI | grep Candle >> /tmp/hebcal.tmp	# Prints candle lighting time for this Shabbos to the same file
hebcal -ZC "${CITY}" $FRI | grep Sunset >> /tmp/hebcal.tmp	# Prints sunset time for Erev Shabbos to same file
hebcal -ZcC "${CITY}" $SAT >> /tmp/hebcal.tmp			# Prints zmanim for Shabbos day and havdala time to same file
if [ $SUPRESS_CAT == false ]; then
	cat /tmp/hebcal.tmp					# Prints file /tmp/hebcal.tmp to terminal unless supressed
fi
if  [ $SUPRESS_LP == false ]; then
	lp /tmp/hebcal.tmp					# Prints file /tmp/hebcal.tmp to line printer unless supressed
fi
rm /tmp/hebcal.tmp						# Removes file /tmp/hebcal.tmp
