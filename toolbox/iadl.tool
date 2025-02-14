#!/bin/bash
# blazing fast download from internet archive

set -e

ITEM=""
DRY_RUN=false
LIST=false

CPU_CORES=$(nproc)
PARALLEL_JOBS=$((CPU_CORES * 2))

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            ;;
        --list)
            LIST=true
            ;;
        -*)
            echo "Unknown option: $1"
            echo "Usage: $0 <item-identifier> [--dry-run]"
            exit 1
            ;;
        *)
            ITEM="$1"
            ;;
    esac
    shift
done

if [[ -z "$ITEM" ]]; then
    echo "Error: No item identifier provided."
    echo "Usage: $0 <item-identifier> [--dry-run]"
    exit 1
fi

if [[ "$DRY_RUN" = true ]]; then
    echo "Running in dry-run mode. No files will be downloaded."
fi

echo -n "Listing remote files: "
readarray -t ARCHIVE_FILES < <(ia list "$ITEM" | sort)
echo "${#ARCHIVE_FILES[@]} files"

if [ ${#ARCHIVE_FILES[@]} -eq 0 ]; then
    echo "Failed to fetch $ITEM"
    exit 0
fi


readarray -t LOCAL_FILES < <(find "$ITEM" -type f | cut -d'/' -f2- | sort)
echo "Local files: ${#LOCAL_FILES[@]} files"

readarray -t MISSING_FILES < <(comm -23 <(printf "%s\n" "${ARCHIVE_FILES[@]}") <(printf "%s\n" "${LOCAL_FILES[@]}"))
echo "Missing files: ${#MISSING_FILES[@]} files"

if [ ${#MISSING_FILES[@]} -eq 0 ]; then
    echo "Files already downloaded"
    exit 0
fi

if [[ "$LIST" = true ]]; then
    for file in "${MISSING_FILES[@]}"; do
        echo "    $file"
    done
fi

if [[ "$DRY_RUN" = false ]]; then
    echo "Downloading missing files..."

    printf "%s\0" "${MISSING_FILES[@]}" | xargs -0 -I {} -P "$PARALLEL_JOBS" sh -c '
        echo -e "[\033[34minfo\033[0m] Download started: {}"
        if ia download --quiet "'"$ITEM"'" "{}"; then
            echo -e "[\033[32msuccess\033[0m] Download ended: {}"
        else
            echo -e "[\033[31merror\033[0m] Download failed: {}" >&2
        fi'
fi
