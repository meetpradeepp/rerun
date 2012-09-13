#!/usr/bin/env bash
#
# NAME
#
#   add-module
#
# DESCRIPTION
#
#   add a new module
#
#/ usage: stubbs:add-module  --module|-m <> --description <>

# Source common function library
source $RERUN_MODULES/stubbs/lib/functions.sh || { echo "failed loading function library" ; exit 1 ; }

rerun_init

# Get the options
while [ "$#" -gt 0 ]; do
    OPT="$1"
    case "$OPT" in
        # options without arguments
	# options with arguments
	-m|--module)
	    rerun_option_check "$#" "$1"
	    MODULE="$2"
	    shift
	    ;;
	--description)
	    rerun_option_check "$#" "$1"
	    DESC="$2"
	    shift
	    ;;
        # unknown option
	-?)
	    rerun_option_usage
        exit 2
	    ;;
	  # end of options, just arguments left
	*)
	    break
    esac
    shift
done

# Post processes the options
[ -z "$MODULE" ] && {
    echo "Module name: "
    read MODULE
}

[ -z "$DESC" ] && {
    echo "Module description: "
    read DESC
}

# Create module structure
mkdir -p $RERUN_MODULES/$MODULE || rerun_die
# Create etc/ subdirectory
mkdir -p $RERUN_MODULES/$MODULE/etc || rerun_die
# Create commands/ subdirectory
mkdir -p $RERUN_MODULES/$MODULE/commands || rerun_die

# Generate a profile for metadata
(
cat <<EOF
# generated by stubbs:add-module
# $(date)
NAME=$MODULE
DESCRIPTION="$DESC"

EOF
) > $RERUN_MODULES/$MODULE/metadata || rerun_die

# Copy a basic function library
mkdir -p $RERUN_MODULES/$MODULE/lib || rerun_die
sed "s/@MODULE@/$MODULE/g" $RERUN_MODULES/stubbs/templates/functions.sh \
   > $RERUN_MODULES/$MODULE/lib/functions.sh || rerun_die

# Done
echo "Created module structure: $RERUN_MODULES/$MODULE"
